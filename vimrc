"                            Pathogen Stuff
"                            --------------
call pathogen#infect()

"                           General Settings
"                           ---------------
filetype indent plugin on                          " turn on plugins
syn on                                             " syntax highlighting on
set t_Co=256                                       " terminal supports colours
set ignorecase                                     " ignore case in matching
set smartcase                                      " match capitals in search
set expandtab                                      " extpand tabs to spaces
set tabstop=4                                      " tab size
set shiftwidth=4                                   " amount to shift by
set softtabstop=4                                  " delete x spaces on backsp.
set scrolloff=8                                    " avoid top/bot of screen
set backspace=indent,eol,start                     " backspace over stuffs
set confirm                                        " do ask for confirmation
set vb t_vb=                                       " turn off visual bell
set lazyredraw                                     " no redraw in macros
set synmaxcol=300                                  " no syn after 300 col
set mouse=                                         " turn off mouse
set shortmess=aT                                   " shorten messages in prompt
set list listchars=tab:»·,trail:·,extends:>,nbsp:_ " visually display whitespace
hi NonText ctermfg=darkgray  guifg=darkgray
hi SpecialKey ctermfg=darkgray guifg=darkgray
set nowrap                                         " allow visual wrapping
set relativenumber                                 " relative numbering sidebar
set showcmd                                        " shows current cmd combo
set noerrorbells                                   " disables error bell
set virtualedit=all                                " allows arbitrary cursor pos
set undodir=~/.vim/undo,.
set undofile
nnoremap j gj
nnoremap k gk
"select last pasted (changed) text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nmap <Leader>- :tabmove -1<cr>
nmap <Leader>+ :tabmove +1<cr>
nmap <Leader>= :%s/<[^>]*>/\r&\r/g<cr>:%g/^$/d<cr>:normal ggVG=<cr>
helptags ~/.vim/doc
colorscheme distinguished
set background=dark
set hlsearch                                       " highlight searches
nmap <F1> :echo "Stop pressing esc in normal mode"<CR>
imap <F1> <Esc>

" Set highlight colour to blue, and keybind to clear highlights
nmap <silent> <Leader>h :nohlsearch<cr>
hi Search guibg=DarkBlue
hi Search ctermbg=DarkBlue
hi Search ctermfg=White

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

" Keybind to replace visual selection with something
vnoremap <C-r> "hy:%s;<C-r>h;;gc<left><left><left>

" Some important top-level remaps
imap <BS> <C-H>
cmap W<cr> up<cr>
nmap <Space> 1<C-D>
nmap ; 1<C-U>
nmap <C-L> zl
nmap <C-H> zh

" Close all folds except the current line
nnoremap zp zMzv

" Y to copy until end of line, like D
map Y y$

" File suffixes that get lower priority in completion
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.ld,.pdf,.ps,.min.js,.min.js.map,.min.css

" Jump to where you were last time in the file on open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Set up omnicompletion functions
set omnifunc=syntaxcomplete#Complete

" Make tags magically close themselves!
" autocmd FileType html imap </ </<C-X><C-O><C-[><<
autocmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType jsp imap </ </<C-X><C-O><C-[><<
autocmd FileType jsp setl ts=2 sw=2 sts=2
autocmd FileType javascript setl omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript setl colorcolumn=81
autocmd FileType javascript setl ts=4 sw=4 sts=4
autocmd FileType c setl omnifunc=ccomplete#Complete
autocmd FileType java setl ts=2 sw=2 sts=2
autocmd FileType go setl list listchars=tab:\ \ ,trail:·,extends:>,nbsp:_
autocmd FileType go setl colorcolumn=81 noexpandtab
autocmd FileType css setl omnifunc=csscomplete#CompleteCSS
autocmd FileType python setl omnifunc=pythoncomplete#Complete
autocmd FileType xml setl omnifunc=xmlcomplete#CompleteTags
autocmd FileType typescript setl colorcolumn=81

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

" Trims trailing whitespace (justinmk)
" ------------------------------------
func! s:trim_whitespace()
  let s=@/
  let w=winsaveview()
  s/\s\+$//ge
  call histdel("/", histnr("/"))
  call winrestview(w)
  let @/=s
endfunc
command! -range=% Trim <line1>,<line2>call s:trim_whitespace()

" Smart Indentation For i
" -----------------------
function! IndentWithI()
    if len(getline('.')) == 0
        return "\"_ddO"
    else
        return "i"
    endif
endfunction
nnoremap <expr> i IndentWithI()

" Copy all matched strings
" ------------------------
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

"                       Location list loop function
"                       ---------------------------
function! WrapCommand(direction)
  if a:direction == "up"
    try
      lprevious
    catch /^Vim\%((\a\+)\)\=:E553/
      llast
    endtry
  elseif a:direction == "down"
    try
      lnext
    catch /^Vim\%((\a\+)\)\=:E553/
      lfirst
    endtry
  endif
endfunction

nmap <Leader>p :call WrapCommand("up")<CR>
nmap <Leader>n :call WrapCommand("down")<CR>

"                              Syntastic
"                              ---------
let g:syntastic_check_on_open=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_typescript_tsc_args = "--module amd"

"                             Tabularize
"                             ----------
nmap <Leader>a, :Tabularize /,\zs<CR>

"                                Gundo
"                                -----
let g:gundo_width = 30
let g:gundo_preview_height = 25
let g:gundo_preview_bottom = 1
nnoremap <silent> <Leader>g :GundoToggle<cr>

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

"                            Control-P Stuff
"                            ---------------
set runtimepath^=~/.vim/bundle/ctrlp.vim
nmap <Leader>t :CtrlP<Cr>
nmap <Leader>r :CtrlPMRU<Cr>
nmap <Leader>c :CtrlPClearCache<Cr>
let g:ctrlp_max_depth=40
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode=0
" Speed up vim in git directories
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
    \ 'fallback': 'find %s -type f'
    \ }
let g:ctrlp_use_caching = 0

let g:ctrlp_extensions = ['funky']
let g:ctrlp_funky_syntax_highlight = 1
nnoremap <Leader>f :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>F :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

"                            UltiSnips Stuff
"                            ---------------
let g:UltiSnipsExpandTrigger="<F3>"
let g:UltiSnipsListSnippets="<F6>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

"                        Load Official matchit.vim
"                        -------------------------
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

"                              Hardtime
"                              --------
let g:hardtime_default_on = 0              " always on

"                           Equal Programs
"                           --------------
if executable('xmllint') == 1
  autocmd FileType xml let &l:equalprg='xmllint --format --recover -'
endif

if executable('tidy') == 1
  autocmd FileType html let &l:equalprg='tidy -quiet --indent yes --show-errors 0'
endif

"                              vim-go
"                              ------
let g:go_fmt_fail_silently = 1

"                          You Complete Me
"                          ---------------
let g:ycm_min_num_of_chars_for_completion = 2

"                             Signify
"                             -------
let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_add               = '+'
let g:signify_sign_change            = '↻'
let g:signify_sign_delete            = ''
let g:signify_sign_delete_first_line = '‾'

"                             Airline
"                             -------

" Simplify the number area to just be line number, col number
let g:airline_section_z = "%2l, %2c"
" Simplify vcs integration to just show branch name
let g:airline_section_b = "%{airline#util#wrap(airline#extensions#branch#get_head(),0)}"

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = ''
let g:airline_right_sep = '«'
let g:airline_right_sep = ''
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'v',
  \ 'V'  : 'V',
  \ '' : '^V',
  \ 's'  : 's',
  \ 'S'  : 'S',
  \ '' : '^S',
  \ }

let g:airline_theme = 'solarized'

let g:airline#extensions#syntastic#enabled = 0

let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#close_symbol = '╳'

"                           Neocomplete
"                           -----------
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
set completeopt-=preview
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

"                      vim-textobj-user
"                      ----------------
call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction

"                   vim-javascript
"                   --------------
let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
