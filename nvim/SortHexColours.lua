-- Function to sort lines by hex colour brightness
function SortHexColoursByBrightness()
  -- Retrieve all lines in the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Function to calculate brightness of a hex colour
  local function calculate_brightness(line)
    -- Match hex colour code (e.g., #1A2B3C)
    local hex = line:match("#%x%x%x%x%x%x")
    if hex then
      -- Extract RGB components
      local r = tonumber(hex:sub(2, 3), 16)
      local g = tonumber(hex:sub(4, 5), 16)
      local b = tonumber(hex:sub(6, 7), 16)
      -- Calculate brightness using luminance formula
      return 0.299 * r + 0.587 * g + 0.114 * b
    else
      -- Assign a default brightness if no hex code is found
      return 0
    end
  end
  
  -- Sort lines based on calculated brightness
  table.sort(lines, function(a, b)
    return calculate_brightness(a) < calculate_brightness(b)
  end)
  
  -- Replace buffer lines with sorted lines
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

-- Create a user command :SortHexBrightness
vim.api.nvim_create_user_command('SortHexCol', SortHexColoursByBrightness, {})
