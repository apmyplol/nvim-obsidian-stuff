O = {}

local status_ok, helpers = pcall(require, "main.helpers")
if not status_ok then
    return
end

local obsidian = require "main.obsidian.obsidian"

local init_autocmd = function()
    vim.opt.shiftwidth = 3
    vim.opt.tabstop = 3
    vim.cmd("set syntax=obsidian")
    -- vim.api.nvim_create_autocmd({"BufWinEnter" }, {
    --     pattern = "*.md",
    --     callback = function()
    --       print("bufwinenter triggered")
    --   --       vim.cmd [[
    --   --   unlet b:current_syntax
    --   --   runtime syntax/tex.vim
    --   -- ]]
    --     end,
    -- })
    --
    -- vim.api.nvim_create_autocmd({ "BufEnter"}, {
    --     pattern = "*.md",
    --     callback = function()
    --       print("bufenter triggered")
    --   --       vim.cmd [[
    --   --   unlet b:current_syntax
    --   --   runtime syntax/tex.vim
    --   -- ]]
    --     end,
    -- })
end

O.hook = function()
    -- when going into workspace wiki then
    -- change clipiboard image path
    local status_ok, clipimage = pcall(require, "clipboard-image")
    if not status_ok then
        return
    end
    clipimage.setup {
        vimwiki = {
            img_dir = { "Bilder" },
            img_dir_txt = "",
            affix = "![[%s]]",
        },
    }

    -- activate autocommand for markdown files
    init_autocmd()

    local status_ok, hologram = pcall(require, "hologram")
    if not status_ok then
        return
    end
    hologram.setup {
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
    }
    -- add vimwiki hotkeys
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

    local opts = { noremap = true, silent = true }
    -- vim.api.nvim_set_keymap("v", "<C-b>", [[<cmd>lua require 'main.helpers'.visual_selection_range()<CR>]], opts)
    which_key.register({
        ["<C-i>"] = { [[c*<c-r>"*]], "surround with *" },
        ["<C-b>"] = { [[c**<c-r>"**]], "surround with **" },
    }, { mode = "v", noremap = true, silent = true, nowait = true })

    which_key.register({
        ["<c-u>"] = { obsidian.fileref_popup, "wikilink autocomplete" },
        ["<c-z>"] = { obsidian.mathlink, "mathlink autocomplete" },
    }, { mode = "i", noremap = true, silent = true, nowait = true })
end

return O
