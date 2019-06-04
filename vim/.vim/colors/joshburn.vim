set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="joshburn"

hi Boolean         guifg=#dca3a3                              ctermfg=181
hi Character       guifg=#dca3a3 gui=bold                     ctermfg=181 cterm=bold
hi Comment         guifg=#7f9f7f gui=italic                   ctermfg=108
hi Conditional     guifg=#f0dfaf gui=bold                     ctermfg=223 cterm=bold
hi Constant        guifg=#dca3a3 gui=bold                     ctermfg=181 cterm=bold
hi Cursor          guifg=#000d18 guibg=#8faf9f gui=bold       ctermfg=233 ctermbg=109 cterm=bold
hi Debug           guifg=#bca3a3 gui=bold                     ctermfg=181 cterm=bold
hi Define          guifg=#ffcfaf gui=bold                     ctermfg=223 cterm=bold
hi Delimiter       guifg=#8f8f8f                              ctermfg=245
hi DiffAdd         guifg=#709080 guibg=#313c36 gui=bold       ctermfg=66  ctermbg=237 cterm=bold
hi DiffChange      guibg=#333333                              ctermbg=236
hi DiffDelete      guifg=#333333 guibg=#464646                ctermfg=236 ctermbg=238
hi DiffText        guifg=#ecbcbc guibg=#41363c gui=bold       ctermfg=217 ctermbg=237 cterm=bold
hi Directory       guifg=#9fafaf gui=bold                     ctermfg=109 cterm=bold
hi ErrorMsg        guifg=#80d4aa guibg=#2f2f2f gui=bold       ctermfg=115 ctermbg=236 cterm=bold
hi Exception       guifg=#c3bf9f gui=bold                     ctermfg=249 cterm=bold
hi Float           guifg=#c0bed1                              ctermfg=251
hi FoldColumn      guifg=#93b3a3 guibg=#3f4040
hi Folded          guifg=#93b3a3 guibg=#3f4040
hi Function        guifg=#efef8f                              ctermfg=228
hi Identifier      guifg=#efdcbc                              ctermfg=223 cterm=none
hi IncSearch       guifg=#f8f893 guibg=#385f38                ctermfg=228 ctermbg=23
hi Keyword         guifg=#f0dfaf gui=bold                     ctermfg=223 cterm=bold
hi Macro           guifg=#ffcfaf gui=bold                     ctermfg=223 cterm=bold
hi ModeMsg         guifg=#ffcfaf gui=none                     ctermfg=223 cterm=none
hi MoreMsg         guifg=#ffffff gui=bold                     ctermfg=231 cterm=bold
hi Number          guifg=#8cd0d3                              ctermfg=116
hi Operator        guifg=#f0efd0                              ctermfg=230
hi PmenuSbar       guibg=#2e3330 guifg=#000000                ctermfg=16  ctermbg=236
hi PmenuThumb      guibg=#a0afa0 guifg=#040404                ctermfg=232 ctermbg=151
hi PreCondit       guifg=#dfaf8f gui=bold                     ctermfg=180 cterm=bold
hi PreProc         guifg=#ffcfaf gui=bold                     ctermfg=223 cterm=bold
hi Question        guifg=#ffffff gui=bold                     ctermfg=231 cterm=bold
hi Repeat          guifg=#ffd7a7 gui=bold                     ctermfg=223 cterm=bold
hi Search          guifg=#ffffe0 guibg=#284f28                ctermfg=230 ctermbg=22
hi SignColumn      guifg=#9fafaf gui=bold                     ctermfg=109 cterm=bold
hi SpecialChar     guifg=#dca3a3 gui=bold                     ctermfg=181 cterm=bold
hi SpecialComment  guifg=#82a282 gui=bold                     ctermfg=108 cterm=bold
hi Special         guifg=#cfbfaf                              ctermfg=181
hi SpecialKey      guifg=#9ece9e                              ctermfg=151
hi Statement       guifg=#e3ceab gui=none                     ctermfg=187 cterm=none
hi StatusLine      guifg=#313633 guibg=#ccdc90                ctermfg=236 ctermbg=186
hi StatusLineNC    guifg=#2e3330 guibg=#88b090                ctermfg=235 ctermbg=108
hi StorageClass    guifg=#c3bf9f gui=bold                     ctermfg=249 cterm=bold
hi String          guifg=#cc9393                              ctermfg=174
hi Structure       guifg=#efefaf gui=bold                     ctermfg=229 cterm=bold
hi Tag             guifg=#e89393 gui=bold                     ctermfg=181 cterm=bold
hi Title           guifg=#efefef gui=bold                     ctermfg=255 ctermbg=NONE cterm=bold
hi Todo            guifg=#dfdfdf guibg=NONE    gui=bold       ctermfg=254 ctermbg=NONE cterm=bold
hi Typedef         guifg=#dfe4cf gui=bold                     ctermfg=253 cterm=bold
hi Type            guifg=#dfdfbf gui=bold                     ctermfg=187 cterm=bold
hi Underlined      guifg=#dcdccc gui=underline                ctermfg=188 cterm=underline
hi VertSplit       guifg=#2e3330 guibg=#688060                ctermfg=236 ctermbg=65
hi VisualNOS       guifg=#333333 guibg=#f18c96 gui=bold,underline ctermfg=236 ctermbg=210 cterm=bold
hi WarningMsg      guifg=#ffffff guibg=#333333 gui=bold       ctermfg=231 ctermbg=236 cterm=bold
hi WildMenu        guifg=#cbecd0 guibg=#2c302d gui=underline  ctermfg=194 ctermbg=236 cterm=underline

" spellchecking, always "bright" term background
hi SpellBad   guisp=#bc6c4c guifg=#dc8c6c  ctermfg=209 ctermbg=237
hi SpellCap   guisp=#6c6c9c guifg=#8c8cbc  ctermfg=103 ctermbg=237
hi SpellRare  guisp=#bc6c9c guifg=#bc8cbc  ctermfg=139 ctermbg=237
hi SpellLocal guisp=#7cac7c guifg=#9ccc9c  ctermfg=151 ctermbg=237

