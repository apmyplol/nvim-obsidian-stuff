-- autocommand for filetype obsidian which is a markdown file in the vault directory (*/wiki/*.md)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*/wiki/*.md",
    callback = function()
        vim.cmd "set filetype=obsidian"
    end,
})
