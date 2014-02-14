"                           General Settings
"                           ---------------
set runtimepath+=$GOROOT/misc/vim                " add golang syntax highlight
filetype indent plugin on                          " turn on plugins
syn on                                             " syntax highlighting on
set t_Co=256                                       " terminal supports colours
set ignorecase                                     " ignore case in matching
set smartcase                                      " match capitals in search
set expandtab                                      " extpand tabs to spaces
set tabstop=2                                      " tab size
set shiftwidth=2                                   " amount to shift by
set softtabstop=2                                  " delete x spaces on backsp.
set scrolloff=8                                    " avoid top/bot of screen
set backspace=indent,eol,start                     " backspace over stuffs
set confirm                                        " do ask for confirmation
set vb t_vb=                                       " turn off visual bell
set mouse=                                         " turn off mouse
set shortmess=aT                                   " shorten messages in prompt
set list listchars=tab:»·,trail:·,extends:>,nbsp:_ " visually display whitespace
hi NonText ctermfg=darkgray  guifg=darkgray
hi SpecialKey ctermfg=darkgray guifg=darkgray
set wrap                                           " allow visual wrapping
"set number                                         " number column
set relativenumber                                 " relative numbering sidebar
set undodir=~/.vim/undo,.
set undofile
set hlsearch                                       " highlight searches
hi Search guibg=DarkBlue
hi Search ctermbg=DarkBlue
hi Search ctermfg=White
nmap <silent> <Leader>h :nohlsearch<cr>
"set colorcolumn=81
nnoremap j gj
nnoremap k gk
nmap <Leader>- :tabmove -1<cr>
nmap <Leader>+ :tabmove +1<cr>
nmap <Leader>n :lnext<cr>
nmap <Leader>p :lprev<cr>
nmap <Leader>= :%s/<[^>]*>/\r&\r/g<cr>:%g/^$/d<cr>:normal ggVG=<cr>
helptags ~/.vim/doc
colorscheme distinguished
set background=dark

au BufRead *sup.*-mode set ft=mail
au BufRead *pde set ft=c
" Next two commands make vim use X11 clipboard
set clipboard=unnamed
nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')
" Make integration stuff
map <F2> :make<cr>
let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

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

" Replace command for visual selection
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

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
autocmd FileType jsp set ts=2 sw=2 sts=2
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript setl omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript setl colorcolumn=81
autocmd FileType javascript setl ts=4 sw=4 sts=4
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set ts=2 sw=2 sts=2
autocmd FileType go set ts=4 sw=4 sts=4 si

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

"                           Less Highlighting
"                           -----------------
au BufRead,BufNewFile *.less setfiletype less
au! Syntax less source $VIMRUNTIME/syntax/sass.vim

"                         Common-Editor Settings
"                         ----------------------
function! CommonEditor()

  " Returns 1 if in an <editor-fold>, otherwise 0
  function! CEInEditorFold(currentLineNum)
    let numlines = line('$')
    let current = a:currentLineNum

    while current >= 0
      if match(getline(current), '<editor-fold') >= 0
        return 1
      elseif match(getline(current), '<\/editor-fold') >= 0
        return 0
      endif

      let current -= 1
    endwhile

    return 0
  endfunction

  " Returns the next line that has a function declaration (only = syntax)
  function! CEFindNextFunction(currentLineNum)
    let numlines = line('$')
    let current = a:currentLineNum

    while current <= numlines
      if match(getline(current), '= function(') >= 0
        return getline(current)
      endif

      let current += 1
    endwhile

    return "UNKNOWN FUNCTION"
  endfunction

  " Fold function for common-editor
  function! CEFolds()
    let thisline = getline(v:lnum)
    let prevline = getline(v:lnum - 1)

    if match(thisline, '<editor-fold') >= 0
      return ">1"
    elseif match(thisline, '^    \/\*\*$') >= 0
      return CEInEditorFold(v:lnum) ? ">2" : ">1"
    elseif match(thisline, '= function(') >= 0 && match(prevline, '^\s*\*\/$') < 0
      return CEInEditorFold(v:lnum) ? ">2" : ">1"
    else
      return "="
    endif
  endfunction

  " Fold text function for common-editor
  function! CEFoldText()
    let foldsize = v:foldend - v:foldstart
    let foldtext = getline(v:foldstart)

    if match(foldtext, '<editor-fold') >= 0
      let foldtext = '  Section: ' . substitute(foldtext, '^.*desc="\(.*\)".*', '\1', '')
    elseif match(foldtext, '^    \/\*\*') >= 0
      let nextfn = CEFindNextFunction(v:foldstart)
      let foldtext = '    Function: ' . substitute(nextfn, '^\s*\([^=]*\).*', '\1', '')
    elseif match(foldtext, '= function(') >= 0
      let foldtext = '    Function: ' . substitute(foldtext, '^\s*\([^=]*\).*', '\1', '')
    endif

    let linecount = ' (' . foldsize .' lines)'
    let spaceamount = 80 - strlen(foldtext) - strlen(linecount)

    return foldtext . repeat(' ', spaceamount) . linecount . repeat(' ', 100)
  endfunction

  " Set the foldmethod to the custom one above
  setlocal foldmethod=expr
  setlocal foldexpr=CEFolds()
  setlocal foldtext=CEFoldText()

  " Automatic opening and closing of folds based on cursor location
  " setlocal foldopen=all
  " setlocal foldclose=all
endfunction
autocmd BufNewFile,BufRead $HOME/Programs/common-editor/*.js call CommonEditor()

"                              Syntastic
"                              ---------
let g:syntastic_check_on_open=1

"                               Taglist
"                               -------
let TList_Inc_Winwidth = 0

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
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:
let g:tex_flavor="latex"

"                            Control-P Stuff
"                            ---------------
set runtimepath^=~/.vim/bundle/ctrlp.vim
nmap <Leader>t :CtrlP<Cr>
nmap <Leader>r :CtrlPMRU<Cr>
nmap <Leader>c :CtrlPClearCache<Cr>
let g:ctrlp_max_depth=40
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode=0
" Makes new tab the default
" let g:ctrlp_prompt_mappings = {
"     \ 'AcceptSelection("e")': ['<c-t>'],
"     \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
"     \ }

"                            UltiSnips Stuff
"                            ---------------
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]
let g:UltiSnipsExpandTrigger="<F5>"
let g:UltiSnipsListSnippets="<F6>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


"                           Delimitmate Stuff
"                           -----------------
" let delimitMate_expand_cr = 1

"                            Pathogen Stuff
"                            --------------
call pathogen#infect()
