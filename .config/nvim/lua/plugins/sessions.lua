return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			session_lens = {
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
      vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
        desc = "Search Session",
      }),
		})
	end,
}
