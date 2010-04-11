" Vim syntax file
" Language:   Markdown
" Maintainer: Andrei Thorp
" URL:
" Version:
" Last Change:

au BufRead,BufNewFile, *.mdwn set filetype=markdown
au Syntax markdown runtime! syntax/markdown.vim
