-- Only run when inside tmux
if vim.env.TMUX then
  -- helper: escape single quotes for safe tmux shell command use
  local function escape_tmux_title(title)
    return title:gsub("'", "'\\''")
  end

  ---[[
  -- Format a full file path according to these rules:
  --
  -- * For a file path inside $HOME (e.g. /home/void/...), the $HOME part is replaced with "~".
  --   - If there are 0 or 1 folders, join them directly.
  --   - If there are exactly 2 folders, show them both with no ellipsis.
  --   - If there are more than 2 folders, collapse the middle folders with an ellipsis so that only
  --     the last folder is shown.
  --
  -- * For a file path outside $HOME (e.g. /etc/...), the same logic applies but the first folder is shown.
  --
  -- If the current buffer is a directory (e.g. browsing), then the title is simply the truncated path.
  -- Otherwise (editing a file) the title is prefixed with "nvim ".
  --
  -- @param full_path string: the absolute path of the file or directory.
  -- @return string: the truncated path (with a prepended "nvim " if appropriate).
  --]]
  local function format_path(full_path)
    if full_path == "" then
      return "nvim"  -- fallback
    end

    local file = vim.fn.fnamemodify(full_path, ":t")
    local dir  = vim.fn.fnamemodify(full_path, ":h")
    local home = vim.env.HOME or ""
    local is_home = home ~= "" and vim.startswith(full_path, home)

    local parts = {}
    local rel_dir

    if is_home then
      -- Remove $HOME from the beginning.
      rel_dir = string.sub(dir, #home + 1)
      -- Remove any leading slash that might remain.
      rel_dir = rel_dir:gsub("^/", "")
    else
      -- For absolute paths, remove the leading slash for splitting.
      rel_dir = dir:gsub("^/", "")
    end

    for part in string.gmatch(rel_dir, "[^/]+") do
      table.insert(parts, part)
    end

    local truncated = ""
    if is_home then
      if #parts == 0 then
        -- File directly in $HOME.
        truncated = "~/" .. file
      elseif #parts == 1 then
        truncated = "~/" .. parts[1] .. "/" .. file
      elseif #parts == 2 then
        -- When there are exactly two folders, show both.
        truncated = "~/" .. parts[1] .. "/" .. parts[2] .. "/" .. file
      else
        -- More than two folders: collapse the middle folders.
        truncated = "~/" .. ".../" .. parts[#parts] .. "/" .. file
      end
    else
      if #parts == 0 then
        truncated = "/" .. file
      elseif #parts == 1 then
        truncated = "/" .. parts[1] .. "/" .. file
      elseif #parts == 2 then
        truncated = "/" .. parts[1] .. "/" .. parts[2] .. "/" .. file
      else
        truncated = "/" .. parts[1] .. "/" .. ".../" .. parts[#parts] .. "/" .. file
      end
    end

    return truncated
  end

  ---[[
  -- Update the tmux window title based on the current buffer.
  --
  -- For directories (e.g. browsing via netrw), the title is the (truncated) directory path.
  -- For files, we prepend "nvim " so that the title will look like:
  --   nvim ~/.../parent/file.txt
  -- or
  --   nvim /first/.../parent/file.txt
  --]]
  local function update_tmux_title()
    local full_path = vim.fn.expand("%:p")
    local title

    if full_path == "" then
      title = "nvim"
    else
      if vim.fn.isdirectory(full_path) == 1 then
        title = format_path(full_path)
      else
        title = "nvim " .. format_path(full_path)
      end
    end

    local escaped = escape_tmux_title(title)
    local cmd = string.format("tmux rename-window '%s'", escaped)
    vim.fn.system(cmd)
  end

  -- (Optional) disable tmux's own automatic-rename so that our manual updates aren’t overwritten.
  vim.fn.system("tmux set-window-option automatic-rename off")

  -- Create an augroup for our tmux title updater.
  local group = vim.api.nvim_create_augroup("TmuxTitle", { clear = true })

  -- Trigger an update on these events: when entering a buffer, a window, or regaining focus.
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
    group = group,
    pattern = "*",
    callback = update_tmux_title,
  })

  -- When vim leaves, re-enable tmux's automatic rename.
  vim.api.nvim_create_autocmd("VimLeave", {
    group = group,
    pattern = "*",
    callback = function()
      vim.fn.system("tmux set-window-option automatic-rename on")
    end,
  })
end
