vim.cmd "let b:current_syntax=''"

-- TODO: Mittelwertsatz highlighing falsch wenn in Zeile 10 keine ^Reference ist
-- syntax für liste
-- stichpunkte
-- Wenn man enter in einer Liste drückt -> neue Zeile fängt mit "-" an

---------------------------------- obsidian syntax stuff ------------------------------------

-- define keywords to make adding highlight groups easier
-- but dont need cluster in keywords because clusteres cannot be highlited
local keywords = {}

-- YAML Frontmatter
vim.cmd [[syntax region ObsYamlFM start=/\%^---/ end=/---/ fold]]
keywords[#keywords+1] = "ObsYamlFM"


-- Headers 1-6
for i = 1, 6, 1 do
    local pattern = "^" .. string.rep("#", i) .. "\\s.*$"
    local name = "ObsH" .. i
    vim.cmd ("syntax match " .. name .. " /" .. pattern .. "/")
    keywords[#keywords+1] = name
end


-- Textblock reference/link names
vim.cmd ([[syntax match ObsTextBlockRef /^\^[^ öüäß]\+/]])
keywords[#keywords+1] = "ObsTextBlockRef"


-- callouts:

-- define callout icons and names
local callouts = {
    Note = "🖊",
    Abstract = "📒",
    Summary = "📒",
    Tldr = "📒",
    Info = "ℹ",
    Todo = "✅",
    Tip = "🔥",
    Hint = "🔥",
    Important = "🔥",
    Success = "✔",
    Check = "✔",
    Done = "✔",
    Question = "❓",
    Help = "❓",
    Faq = "❓",
    Warning = "⚠",
    Caution = "⚠",
    Attention = "⚠",
    Failure = "❌",
    Fail = "❌",
    Missing = "❌",
    Danger = "⚡",
    Error = "⚡",
    Bug = "🐞",
    Example = "🙆",
    Quote = "💬",
    Cite = "💬",
}


-- create syntax cluster for callout icons and keywords for each type of callout
for word, icon in pairs(callouts) do
  local ref = "ObsCallout" .. word
  vim.cmd ("syntax keyword " .. ref .. " " ..  word:lower() .. " conceal contained cchar=" .. icon)
  vim.cmd("syntax cluster ObsCalloutIcons add=ObsCallout" .. word)
  vim.cmd("hi def link " .. ref .. " " .. ref)
end


-- callout header line, header (the thing that defines the type of callout) and header "title"
vim.cmd "syntax match ObsCalloutHead /\\[[^\\]]*/me=e+2,he=e+2 contains=@ObsCalloutIcons contained conceal"
vim.cmd [[syntax match ObsCalloutTitle /[^]+-]\+$/ contains=@mathjax contained]]
vim.cmd [[syntax match ObsCalloutHeadline /^>\s\[.*/ contains=ObsCalloutHead,ObsCalloutTitle contained]]
keywords[#keywords+1] = "ObsCalloutTitle"
keywords[#keywords+1] = "ObsCalloutHeadline"

-- finally define callouts
vim.cmd [[syntax region ObsCallout start=/^>\s\[/ end=/^>\s[^[].*$\n[^>]/me=e-1 contains=ObsCalloutHeadline,ObsLink,@mathjax keepend fold nextgroup=ObsTextBlockRef]]
keywords[#keywords+1] = "ObsCallout"


-- quotes
vim.cmd [[syntax region ObsQuote start=/^>\s[^[]/ end=/^>\s[^[]*\n\([^>]\|\n\)/me=e-1 fold contains=ObsLink,@mathjax,ObsCalloutHeadline keepend nextgroup=ObsTextBlockRef]]
keywords[#keywords+1] = "ObsQuote"


-- Wikilinks with [[link|rename]] form
vim.cmd [[syntax region ObsLink matchgroup=ObsLinkBraces start =/\[\[/ end=/\]\]/ contains=ObsLinkDest,ObsLinkName,ObsLinkNoRename oneline concealends]]
vim.cmd "syntax match ObsLinkDest /\\[[^]|[]\\+[|]\\=/ms=s+1,lc=1 contained nextgroup=ObsLinkName conceal"
vim.cmd "syntax match ObsLinkName /|[^]]\\+\\]/ms=s+1,me=e-1,ms=s+1,he=e-1,lc=1 contained"
vim.cmd [[syntax match ObsLinkNoRename /\[[^]|[]\+\]/ms=s+1,me=e-1,lc=1 contained]]


-- tags
vim.cmd [[syntax match ObsTag /#[^# ]\+/]]
keywords[#keywords+1] = "ObsTag"


-- italics, bold and bold+italics
vim.cmd [[syntax region ObsItalics matchgroup=ObsItalicsDelim start=/\*[^*]/rs=e-1 end=/\*/ concealends]]
vim.cmd [[syntax region ObsBold  matchgroup=ObsBoldDelim start=/\*\*[^*]/rs=e-1 end=/\*\*/ concealends]]
vim.cmd [[syntax region ObsBoldItalics matchgroup=ObsBoldItDelim start=/\*\*\*[^*]/rs=e-1 end=/\*\*\*/ concealends]]
keywords[#keywords+1] = "ObsItalics"
keywords[#keywords+1] = "ObsBold"
keywords[#keywords+1] = "ObsBoldItalics"


-- single ticks code blocks
vim.cmd [[syntax region ObsSingleTicks matchgroup=ObsSingleTicksDelim start=/`[^`]/rs=e-1 end=/`/ oneline concealends]]
keywords[#keywords+1] = "ObsSingleTicks"

vim.cmd "unlet b:current_syntax"
vim.cmd "syntax include @Python syntax/python.vim"
vim.cmd [[syntax region ObsTriTicks matchgroup=ObsTriTicksDelim start=/```/ end=/```/  contains=ObsPyBlock]]
keywords[#keywords+1] = "ObsTriTicks"
vim.cmd [[syntax region ObsPyBlock matchgroup=ObsPyBlockDelim start=/python/ end=/```/he=e-3,me=e-3 contained contains=@Python]]
keywords[#keywords+1] = "ObsPyBlockDelim"







--------------------------------------------- mathjax syntax stuff -------------------------------------


-- import tex stuff from lervag/vimtex
vim.cmd "unlet b:current_syntax"
vim.cmd "syntax include TexMathDelimTD TexMathDelimTL syntax/tex.vim"



-- obsidian links inside math blocks
vim.cmd [[syntax region TexLink matchgroup=TexLinkBraces start=/\\href{/ end=/}/ oneline concealends contains=TexLinkDest,TexLinkHide containedin=@texClusterMath]]
vim.cmd "syntax match TexLinkHide /[^}]*&file=/ contained conceal"
vim.cmd [[syntax match TexLinkDest /&file=[^}]\+}/ms=s+6,hs=s+6,me=e-1,he=e-1,lc=6 contained conceal]]
keywords[#keywords+1] = "TexLink"


-- mathjax syntax groups
vim.cmd [[syntax region MathjaxInline matchgroup=MathjaxInlineDelim start=/\$/ end=/\$/ contains=@texClusterMath concealends]]
vim.cmd [[syntax region MathjaxBlock matchgroup=MathjaxBlockDelim start=/\$\$/ end=/\$\$/ contains=@texClusterMath keepend concealends]]
vim.cmd "syntax cluster mathjax contains=MathjaxBlock,MathjaxInline"












--------------------------------------- adding links for highlighting -----------------------------------

-- create links to hi groups
for _, keyword in ipairs(keywords) do
  vim.cmd("hi def link " .. keyword .. " " .. keyword)
end
