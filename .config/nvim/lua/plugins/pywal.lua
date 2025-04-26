return {
  "AlphaTechnolog/pywal.nvim",
      lazy = false,    -- Load the colorscheme early, as it needs to be available for the UI
      priority = 1000, -- Ensure it loads before other plugins that might set colors/highlights
      config = function()
        vim.cmd("colorscheme pywal")
      end, 
}
