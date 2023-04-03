vim.cmd "let b:current_syntax=''"

-- import tex stuff from lervag/vimtex
vim.cmd "unlet b:current_syntax"
vim.cmd "syntax include TexMathDelimTD TexMathDelimTL syntax/tex.vim"

vim.cmd("syntax iskeyword @,48-57,a-z,A-Z,192-255,.,+,-,>")

-- TODO: 
-- syntax für liste
-- stichpunkte
-- Wenn man enter in einer Liste drückt -> neue Zeile fängt mit "-" an

---------------------------------- obsidian syntax stuff ------------------------------------

-- define keywords to make adding highlight groups easier
-- but dont need cluster in keywords because clusteres cannot be highlited
local keywords = {}

-- YAML Frontmatter
vim.cmd [[syntax region ObsYamlFM start=/\%^---/ end=/---/ fold]]
keywords[#keywords + 1] = "ObsYamlFM"

-- Headers 1-6
for i = 1, 6, 1 do
    local pattern = "^" .. string.rep("#", i) .. "\\s.*$"
    local name = "ObsH" .. i
    vim.cmd("syntax match " .. name .. " /" .. pattern .. "/")
    keywords[#keywords + 1] = name
end

-- Textblock reference/link names
vim.cmd [[syntax match ObsTextBlockRef /^\^[^ öüäß]\+/]]
keywords[#keywords + 1] = "ObsTextBlockRef"

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
    vim.cmd("syntax keyword " .. ref .. " " .. word:lower() .. " conceal contained cchar=" .. icon)
    vim.cmd("syntax cluster ObsCalloutIcons add=ObsCallout" .. word)
    vim.cmd("hi def link " .. ref .. " " .. ref)
end

-- callout header line, header (the thing that defines the type of callout) and header "title"
vim.cmd "syntax match ObsCalloutHead /\\[![^\\]]*/me=e+2,he=e+2 contains=@ObsCalloutIcons contained conceal"
vim.cmd [[syntax match ObsCalloutTitle /[^]+-]\+$/ contains=@mathjax contained]]
vim.cmd [[syntax match ObsCalloutHeadline /^>\s\[!.*/lc=2 contains=ObsCalloutHead,ObsCalloutTitle contained]]
keywords[#keywords + 1] = "ObsCalloutTitle"
keywords[#keywords + 1] = "ObsCalloutHeadline"

-- finally define callouts
vim.cmd [[syntax region ObsCallout start=/^>\s\[/ end=/^>\s[^[].*$\n\([^>]\|\n\)/me=e-1 contains=ObsCalloutHeadline,@ObsLinks,@mathjax keepend fold nextgroup=ObsTextBlockRef]]
keywords[#keywords + 1] = "ObsCallout"

-- quotes
vim.cmd [[syntax region ObsQuote start=/^>\s[^[]/ end=/^>\s[^[]*\n\([^>]\|\n\)/re=e-2,me=e-2,lc=3 fold contains=@ObsLinks,@mathjax keepend nextgroup=ObsTextBlockRef]]
vim.cmd([[syntax keyword ObsQuoteChar > containedin=ObsQuote,ObsCallout conceal cchar=┃ contained]])
keywords[#keywords + 1] = "ObsQuote"

-- Wikilinks with [[link|rename]] form
vim.cmd [[syntax region ObsLink matchgroup=ObsLinkBraces start =/\[\[/ end=/\]\]/ contains=ObsLinkDest,ObsLinkName,ObsLinkNoRename oneline concealends containedin=ALL]]
vim.cmd "syntax match ObsLinkDest /\\[[^]|[]\\+[|]\\=/ms=s+1,lc=1 contained nextgroup=ObsLinkName conceal"
vim.cmd "syntax match ObsLinkName /|[^]]\\+\\]\\]/ms=s+1,me=e-2,ms=s+1,he=e-2,lc=1 contained"
vim.cmd [[syntax match ObsLinkNoRename /\[\[[^]|[]\+\]\]/ms=s+2,me=e-2,lc=2 contained]]

-- wikilinks with round braces in [rename](link) form
vim.cmd("syntax match ObsLinkR /\\[.\\{-1,}\\](.\\{-1,})/")
vim.cmd "syntax region ObsLinkRName matchgroup=ObsLinkRNameBraces start=/\\[[^![]/rs=e-1 end=/\\][^]]/me=e-1 oneline nextgroup=ObsLinkRDest concealends containedin=ObsLinkR contained"
vim.cmd "syntax region ObsLinkRDest matchgroup=ObsLinkRDestBraces start=/\\](/ms=s+1,lc=1 end=/)/ conceal containedin=ObsLinkR"
vim.cmd "syntax region ObsLinkRNoRename matchgroup=ObsLinkRNoRenameBraces start=/\\[\\](/ end=/)/ concealends containedin=ObsLinkR"
-- define highlights for links with this form
vim.cmd("hi def link ObsLinkRName ObsLinkName")
vim.cmd("hi def link ObsLinkRDest ObsLinkDest")
vim.cmd("hi def link ObsLinkRNoRename ObsLinkNoRename")

vim.cmd "syntax cluster ObsLinks contains=ObsLink,ObsLinkDest,ObsLinkName,ObsLinkNoRename,ObsLinkRDest,ObsLinkRName,ObsLinkRNoRename,ObsLinkR"

-- tags
vim.cmd [[syntax match ObsTag /#[^# ]\+/]]
keywords[#keywords + 1] = "ObsTag"

-- italics, bold and bold+italics
vim.cmd [[syntax region ObsItalics matchgroup=ObsItalicsDelim start=/\*[^*]/rs=e-1 end=/\*/ concealends containedin=ALL]]
vim.cmd [[syntax region ObsBold  matchgroup=ObsBoldDelim start=/\*\*[^*]/rs=e-1 end=/\*\*/ concealends containedin=ALL]]
vim.cmd [[syntax region ObsBoldItalics matchgroup=ObsBoldItDelim start=/\*\*\*[^*]/rs=e-1 end=/\*\*\*/ concealends containedin=ALL]]
keywords[#keywords + 1] = "ObsItalics"
keywords[#keywords + 1] = "ObsBold"
keywords[#keywords + 1] = "ObsBoldItalics"

-- single ticks code blocks
vim.cmd [[syntax region ObsSingleTicks matchgroup=ObsSingleTicksDelim start=/`[^`]/rs=e-1 end=/`/ oneline concealends containedin=ALL]]
keywords[#keywords + 1] = "ObsSingleTicks"

vim.cmd "unlet b:current_syntax"
vim.cmd "syntax include @Python syntax/python.vim"
vim.cmd [[syntax region ObsTriTicks matchgroup=ObsTriTicksDelim start=/```/ end=/```/  contains=ObsPyBlock]]
keywords[#keywords + 1] = "ObsTriTicks"
vim.cmd [[syntax region ObsPyBlock matchgroup=ObsPyBlockDelim start=/python/ end=/```/he=e-3,me=e-3 contained contains=@Python]]
keywords[#keywords + 1] = "ObsPyBlockDelim"



vim.cmd([[syntax match ObsBullet /[+-]\s.*/ containedin=ObsQuote contains=@mathjax]])
vim.cmd([[syntax keyword ObsBulletMin - containedin=ObsBullet conceal cchar=•]])
vim.cmd([[syntax keyword ObsBulletPl + containedin=ObsBullet conceal cchar=•]])
vim.cmd([[syntax match ObsNumbers /\d\+\.\s.*/ containedin=ObsQuote,ObsCallout contains=@mathjax]])

-- local numbers = {"1️⃣" ,  "2️⃣" , "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟"}
local numbers = {"①","②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩"}
-- create syntax cluster for callout icons and keywords for each type of callout
-- syntax keyword ObsNumber1 1\. containedin=ObsNumbers

for number, icon in pairs(numbers) do
    local ref = "ObsNumber" .. tostring(number)
    vim.cmd("syntax keyword " .. ref .. " " .. tostring(number) .. ". conceal containedin=ObsNumbers cchar=" .. icon)
end

--------------------------------------------- mathjax syntax stuff -------------------------------------


-- obsidian links inside math blocks
-- vim.cmd [[syntax region TexLink matchgroup=TexLinkBraces start=/\\href{/ end=/}/ oneline concealends contains=TexLinkDest,TexLinkHide containedin=@texClusterMath]]
-- vim.cmd "syntax match TexLinkHide /[^}]*&file=/ contained conceal"
-- vim.cmd [[syntax match TexLinkDest /&file=[^}]\+}/ms=s+6,hs=s+6,me=e-1,he=e-1,lc=6 contained conceal]]
keywords[#keywords + 1] = "TexLink"
vim.cmd "syntax match TexLink /\\href{.\\{-}}{.\\{-}}/"

-- mathjax syntax groups
vim.cmd [[syntax region MathjaxInline matchgroup=MathjaxInlineDelim start=/\$[^$]/ms=e-1,rs=e-1 end=/\$/ms=s-1 contains=@texClusterMath concealends]]
vim.cmd [[syntax region MathjaxBlock matchgroup=MathjaxBlockDelim start=/\$\$/ end=/\$\$/ contains=@texClusterMath keepend concealends]]
vim.cmd "syntax cluster mathjax contains=MathjaxBlock,MathjaxInline"

--------------------------------------- adding links for highlighting -----------------------------------

-- create links to hi groups
for _, keyword in ipairs(keywords) do
    vim.cmd("hi def link " .. keyword .. " " .. keyword)
end
