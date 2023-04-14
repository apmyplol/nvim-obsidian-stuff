M = {}

M.enter_key_normal = function()
    local pos =
        vim.api.nvim_command_output [[echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' > ')]]
    if pos:match "ObsLink" then -- wenn in normal mode über einem link
        -- 3 Fälle: markdown datei ohne suffix, random datei mit suffix, random datei mit suffix mit vollem path
        vim.cmd "set suffixesadd=.md"
        ok, _ = pcall(vim.cmd, "normal gf")
        if not ok then
            local first_10_lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
            local yaml = table.concat(first_10_lines, "\n"):match "^%-%-%-\n(.*)%-%-%-"
            local _, yaml_length = string.gsub(yaml, "\n", "\n")
            vim.cmd "e <cfile>.md"
            if yaml and vim.api.nvim_buf_line_count(0) == 1 then
                local input_tab = { "---" }
                for i = 1, yaml_length do
                    input_tab[#input_tab + 1] = first_10_lines[i + 1]
                end
                input_tab[#input_tab + 1] = "---"
                vim.api.nvim_buf_set_lines(0, 0, 0, false, input_tab)
            end
        end
    else -- if not link then create link
        vim.cmd "normal viwsL%"
    end
end

M.enter_key_insert = function()
    local reg = vim.regex [[^\(> \)\?\(\d. \|[+-] \)\?]]
    local line = vim.api.nvim_get_current_line()
    print(line)
    m1, m2 = reg:match_str(line)
    -- local cur_pos = vim.api.nvim_win_get_cursor(0)[1]
    
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    if m1 ~= m2 then
        local subline = line:sub(m1, m2)
        subline = subline:match "%d" and subline:gsub("%d", tonumber(subline:match "%d") + 1) or subline
        vim.api.nvim_feedkeys(subline, "n", false)
    end
end

return M
