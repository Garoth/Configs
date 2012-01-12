"                           General Settings
"                           ---------------
syn on                                             " syntax highlighting on
filetype indent plugin on                          " turn on plugins
set ignorecase                                     " ignore case in matching
set smartcase                                      " override ignorecase if a capital is typed
set expandtab                                      " extpand tabs to spaces
set tabstop=4                                      " tab size
set shiftwidth=4                                   " amount to shift by
set softtabstop=4                                  " allows you to delete 8 spaces when backspacing a   " tab "
set scrolloff=8                                    " don't touch top/bottom of screen by this many
set backspace=indent,eol,start                     " allow backspacing over all sorts of stuff
set nohlsearch                                     " don't highlight previous search matches
set confirm                                        " do ask for confirmation
set vb t_vb=                                       " turn off visual bell
set mouse=                                         " turn off mouse
set shortmess=a                                    " use abbreviations like [NEW] instead of [NEW FILE]
set list listchars=tab:»·,trail:·,extends:>,nbsp:_ " visually display whitespace
set wrap                                           " allow visual wrapping
set nobackup                                       " don't make backup files

au BufRead *sup.*-mode set ft=mail
au BufRead *pde set ft=c
" Next two commands make vim use X11 clipboard
set clipboard=unnamed
nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')
" Make integration stuff
map <F2> :make<cr>
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

" Highlights
highlight SpellBad ctermbg=lightyellow ctermfg=black
highlight OverLength ctermbg=lightblue ctermfg=black
function! s:setoverlength(col)
    exe 'match OverLength "\%' . a:col . 'v.*"'
endfunction
command! -nargs=1 SetOverLength call s:setoverlength(<args>)
SetOverLength 81

" Statusline (largely frogonweels)
set statusline=                                 " Clear statusline
set statusline+=[%n]                            " Buffer number
set statusline+=\ %<%.99f                       " Filename
set statusline+=\ %h                            " help file flag
set statusline+=%w                              " preview window flag [Preview]
set statusline+=%m                              " modified flag
set statusline+=%r                              " read only flag
set statusline+=%y                              " filetype
set statusline+=[%{strlen(&fenc)?&fenc:'none'}] " file encoding
set statusline+=%=                              " right/left separator
set statusline+=%-16(\ %l,%c-%v\ %)             " line number, column number - visual column number
set statusline+=%P                              " percent through file
set laststatus=2                                " Always on

imap <BS> <C-H>
cmap W<cr> up<cr>
nmap <Space> 1<C-D>
nmap ; 1<C-U>
" Y to copy until end of line, like D
map Y y$
" File suffixes that get lower priority in completion
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.ld,.pdf,.ps
" Jump to where you were last time in the file on open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Set up omnicompletion functions
set omnifunc=syntaxcomplete#Complete

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" Make tags magically close themselves!
autocmd FileType html imap </ </<C-X><C-O><C-[><<
autocmd FileType jsp imap </ </<C-X><C-O><C-[><<
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript SetOverLength 101
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType jsp set ts=2 sw=2 sts=2

" graywh -- formatting
set formatoptions=
set formatoptions+=c  " Format comments
set formatoptions+=r  " Continue comments by default
set formatoptions+=o  " Make comment when using o or O from comment line
set formatoptions+=q  " Format comments with gq
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=2  " Use indent from 2nd line of a paragraph
set formatoptions+=l  " Don't break lines that are already long
set formatoptions+=t  " Wrap when using textwidth
set formatoptions+=1  " Break before 1-letter words
set formatlistpat=^\\s*\\(\\d\\+\\\|\\*\\\|-\\\|•\\)[\\]:.)}\\t\ ]\\s*

"                           Vala Highlighting
"                           -----------------
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala setfiletype vala
au BufRead,BufNewFile *.vapi setfiletype vala
au! Syntax vala source $VIM/syntax/cs.vim

"                      Always On Rainbow Parentheses
"                      -----------------------------
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadChevrons

"                              Java Hacks
"                              ----------
autocmd BufNewFile *.java call NewJavaFile()
" Create a template on new Java File
function! NewJavaFile()
        let filename = expand("%:t:r")
        let comment = "/* " . filename . " Class File */"
        let constructor = "    /* Constructor */\<NL>" .
                \ "    public " . filename .
                \ "() {\<NL>    }"
        let function = "public class " . filename . " {\<NL>\<NL>" .
                \ constructor . "\<NL>}"

        -put =comment
        $put =function
endfunction

nnoremap <Leader>jp :call InsertPackageStatement()<CR>
" Generates a package statement for the current file
" Limitation: assumes that the src/ folder is just above the package structure
function! InsertPackageStatement()
        let path = substitute(expand('%:p'), '.*src/', '', '')
        let path = substitute(path, '/' . expand('%') . "$", '', '')
        let path = "package " . substitute(path, '/', '.', 'g') . ';'

        -put =path
endfunction

" Returns a string of spaces of length &tabstop
function! GetTabSpace()
        return repeat(' ', &tabstop)
endfunction

nnoremap <Leader>ja :call InsertAccessorStatements(input('Variable Type: '),
        \ input('Variable Name: '))<CR>
" Generates getter, setter, and instance variable for given variable name
function! InsertAccessorStatements(type, varname)
        echo 'Generating Instance, Getter, Setter'
        let blank = ''
        let instance = 'private ' . a:type . ' ' . a:varname . ';'
        let getter = 'public ' . a:type . ' get' .
                \ toupper(strpart(a:varname, 0, 1)) . strpart(a:varname, 1) .
                \ "() {\<NL>" . GetTabSpace() . 'return this.' . a:varname .
                \ ";\<NL>}"
        let setter = 'public void set' .
                \ toupper(strpart(a:varname, 0, 1)) . strpart(a:varname, 1) .
                \ "(" . a:type . ' ' . a:varname . ") {\<NL>" . GetTabSpace() .
                \ 'this.' . a:varname . ' = ' . a:varname .  ";\<NL>}"

        put =instance
        put =blank
        put =getter
        put =blank
        put =setter
endfunction

nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>

"                          Paren Autocompletion
"                          ---------------------
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
function ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endf

"                           Auto Add Modeline
"                           -----------------
" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.': '
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

"                            Vim-Latex Stuff
"                            ---------------
" IMPORTANT: grep will sometimes skip displaying the file name if you
" " search in a singe file. This will confuse Latex-Suite. Set your grep
" " program to alway generate a file-name.
set grepprg=grep\ -nH\ $*
" TIP: if you write your \label's as \label{fig:something}, then if you
" " type in \ref{fig: and press <C-n> you will automatically cycle through
" " all the figure labels. Very useful!
set iskeyword+=:
let g:tex_flavor="latex"

"                             Pathogen Stuff
"                             --------------
call pathogen#infect()

"                            Command-T Stuff
"                            ---------------
let g:CommandTAcceptSelectionTabMap='<CR>'
let g:CommandTAcceptSelectionMap='<C-b>'
let g:CommandTCancelMap='<Esc>'
