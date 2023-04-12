M = {}

M.enter_key = function()
    local line = vim.api.nvim_get_current_line()
    local pos =
        vim.api.nvim_command_output [[echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' > ')]]

    if line:match "^([+-])" or line:match "^> (+-)" then -- checken ob zeile mit - oder > - anfängt
        print "normal text block"
    -- s:match("%[([^[%s]+)[[|]")
    elseif true then -- wenn in normal mode über einem link
        local filename = line:match("%[%[([^|%]]+)"):gsub(" ", "\\ ")
        -- 3 Fälle: markdown datei ohne suffix, random datei mit suffix, random datei mit suffix mit vollem path
    end
end

return M
