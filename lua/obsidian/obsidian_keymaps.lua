local obsidian = require "obsidian.obsidian"

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

which_key.register {
    ["<CR>"] = { obsidian.enter_key, "Vimwiki Follow Link" },
    h = {
        function()
            obsidian.preview_image(true)
        end,
        "preview image for 5 seconds that is on the line where the cursor is on",
    },
    H = {
        function()
            obsidian.preview_image(false)
        end,
        "preview image that is on the line where the cursor is on",
    },
    ["<leader>W"] = {
        j = { "<cmd>VimwikiNextLink<cr>", "goto Next wiki link" },
        k = { "<cmd>VimwikiPrevLink<cr>", "goto prev wiki link" },
        c = { "<cmd>!xdg-open 'obsidian://open?vault=wiki&file=%'<cr><cr>", "opens current file in obsidian" },
        p = { "<cmd>PasteImg<cr>", "paste image from clipboard" },
    },
    ["<leader>f"] = { obsidian.findfile, "find file in wiki" },
    ["<leader>F"] = {
        obsidian.nonwiki,
        "open non wiki file such as pdf",
    },
    ["<c-l>"] = { [[llvf|h"lxxvwh"nxhxx"nPla(<c-r>l)]], "change link format to [ref](link)" },
}

which_key.register({
    ["<C-i>"] = { [[c*<c-r>"*]], "surround with *" },
    ["<C-b>"] = { [[c**<c-r>"**]], "surround with **" },
}, { mode = "v", noremap = true, silent = true, nowait = true })

which_key.register({
    ["<c-u>"] = { obsidian.fileref_popup, "wikilink autocomplete" },
    ["<c-z>"] = { obsidian.mathlink, "mathlink autocomplete" },
}, { mode = "i", noremap = true, silent = true, nowait = true })
