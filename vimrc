"                           General Settings
"                           ---------------
syn on
" Note: plugin is important to invoke latex-suite
filetype indent plugin on
set ignorecase
set smartcase
set expandtab
set tabstop=8
set shiftwidth=8
set softtabstop=8
set scrolloff=8
set backspace=indent,eol,start
set nohlsearch
set confirm
set vb t_vb=
set shortmess=a
set list listchars=tab:»·,trail:·,extends:>,nbsp:_
" Turn the mouse off (Arch sets it by default)
set mouse=
" set foldenable
" set foldmethod=syntax
" set foldlevel=100
au BufRead *sup.*-mode set ft=mail
au BufRead *pde set ft=c
" Next two commands make vim use X11 clipboard
set clipboard=unnamed
:nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')
" Make integration stuff
map <F2> :make<Enter>
nmap e :cn<Enter>
nmap E :cN<Enter>
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat 
" Highlight characters that go over 80 columns
:highlight OverLength ctermbg=blue ctermfg=white guibg=blue guifg=white
" :match OverLength '\%82v.*'
imap <BS> <C-H>
cmap W<cr> w<cr>

"                           Vala Highlighting
"                           -----------------
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype vala
au BufRead,BufNewFile *.vapi            setfiletype vala
au! Syntax vala source $VIM/syntax/cs.vim

"
"                              Java Hacks
"                              ----------
" General Settings
let java_mode = 1
if java_mode == 1
        set shiftwidth=4
        set tabstop=4
        set softtabstop=4
        set expandtab
endif

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

" Configure the JavaBrowser plugin
let JavaBrowser_Ctags_Cmd = '/usr/bin/ctags'
let JavaBrowser_Inc_Winwidth = 0
let JavaBrowser_Compact_Format = 1
let JavaBrowser_Use_Text_Icon = 0
let JavaBrowser_Use_Icon = 0
let JavaBrowser_Use_Highlight_Tag = 1
nnoremap <Leader>jb :JavaBrowser<CR>

" Set up JavaComplete plugin
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
inoremap <buffer> <C-Space> <C-X><C-O>

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
