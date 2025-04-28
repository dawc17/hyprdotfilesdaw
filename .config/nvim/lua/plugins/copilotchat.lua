return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      window = {
        layout = "vertical",
        width = 0.35,
        height = 0.5,
      },
      question_header = "",
      answer_header = "",
      error_header = "",
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
