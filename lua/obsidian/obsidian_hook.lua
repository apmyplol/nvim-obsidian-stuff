-- obsidian hook file for the workspaces plugin
return function()
    -- set some options that get enabled when opening the wiki workspace
    vim.opt.shiftwidth = 3
    vim.opt.tabstop = 3
    vim.opt.wrap = false

    -- when going into workspace wiki then change the clipboard image path
    local status_ok, clipimage = pcall(require, "clipboard-image")
    if not status_ok then
        print "could not require clipboard-image"
        return
    end
    clipimage.setup {
        obsidian = {
            img_dir = { "Bilder" },
            img_dir_txt = "",
            affix = "![[%s]]",
        },
    }

    -- add obsidian keymaps
    require "obsidian.obsidian_keymaps"

    local status_ok, hologram = pcall(require, "hologram")
    if not status_ok then
        return
    end
    hologram.setup {
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
    }
end
