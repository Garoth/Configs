set ft=Wikipedia
so $HOME/.vim/syntax/Wikipedia.vim

" Set up some colour styles
highlight WikiTitle      ctermfg=blue
highlight WikiFormatChar ctermfg=green

" Override some Wikipedia.vim colours
hi link htmlH1             WikiTitle
hi link wikiParaFormatChar WikiFormatChar
hi link wikiLink           LineNr
