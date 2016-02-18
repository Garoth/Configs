" let g:python_host_prog='/usr/local/bin/python'
" let g:python3_host_prog = '/usr/local/bin/python3'

function! VimrcLoadPlugins()
  let g:vim_plug_dir = $HOME.'/.nvim'

  " Install vim-plug if not available
  if !isdirectory(g:vim_plug_dir)
    call mkdir(g:vim_plug_dir, 'p')
  endif
  if !filereadable(g:vim_plug_dir.'/autoload/plug.vim')
    execute '!git clone git://github.com/junegunn/vim-plug '
          \ shellescape(g:vim_plug_dir.'/autoload', 1)
  endif

  " Starting plugin setup
  call plug#begin()

  " Misc
  Plug 'Raimondi/delimitmate'
  Plug 'Valloric/MatchTagAlways'
  Plug 'chrisbra/Colorizer'
  Plug 'ap/vim-css-color'
  Plug 'groenewege/vim-less'
  Plug 'guns/xterm-color-table.vim'
  Plug 'honza/vim-snippets'
  Plug 'jakar/vim-AnsiEsc'
  Plug 'jceb/vim-textobj-uri'
  Plug 'justinmk/vim-gtfo'
  Plug 'kana/vim-textobj-user'
  Plug 'leafgarland/typescript-vim'
  Plug 'mkitt/tabline.vim'
  Plug 'moll/vim-bbye'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'romainl/vim-qf'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-jdaddy'
  Plug 'tpope/vim-markdown'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'unblevable/quick-scope'
  Plug 'whatyouhide/vim-textobj-xmlattr'

  " Stuff to look into
  " Plug 'tpope/vim-repeat'
  " Plug 'Shougo/vinarise.vim'
  " Plug 'Valloric/python-indent'
  " Plug 'rking/ag.vim'
  " Plug 'nicklasos/vim-jsx-riot'

  " vim-javascript
  " --------------
  Plug 'pangloss/vim-javascript'
  let g:javascript_conceal_function   = "f"
  let g:javascript_conceal_null       = "Π"
  let g:javascript_conceal_this       = "@"
  let g:javascript_conceal_return     = "⇚"
  let g:javascript_conceal_undefined  = "¿"
  let g:javascript_conceal_NaN        = "ℕ"
  let g:javascript_conceal_prototype  = "¶"
  set conceallevel=1

  " vim-jsx
  " Plug 'mxw/vim-jsx'
  " let g:jsx_ext_required = 0

  " NERDtree
  " --------
  Plug 'scrooloose/nerdtree'
  let g:NERDTreeChDirMode=2
  let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
  let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
  let g:NERDTreeShowBookmarks=1
  let g:nerdtree_tabs_focus_on_files=1
  let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
  let g:NERDTreeWinSize = 50
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
  nnoremap <silent> <F2> :NERDTreeFind<CR>
  noremap <F3> :NERDTreeToggle<CR>

  " Syntastic
  " Plug 'scrooloose/syntastic'
  " let g:syntastic_check_on_open=1
  " let g:syntastic_always_populate_loc_list=1
  " let g:syntastic_typescript_tsc_args = "--module amd"

  " Neomake
  Plug 'benekastah/neomake'
  autocmd! BufWritePost * Neomake

  " Tabular
  Plug 'godlygeek/tabular'
  nmap <Leader>a, :Tabularize /,\zs<CR>

  " gundo
  Plug 'sjl/gundo.vim'
  let g:gundo_width = 30
  let g:gundo_preview_height = 25
  let g:gundo_preview_bottom = 1
  nnoremap <silent> <Leader>g :GundoToggle<cr>

  " vim-signify
  Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = [ 'git' ]
  let g:signify_sign_add               = '+'
  let g:signify_sign_change            = '↻'
  let g:signify_sign_delete            = ''
  let g:signify_sign_delete_first_line = '‾'

  " vim-go
  Plug 'fatih/vim-go'
  let g:go_fmt_fail_silently = 1
  let g:go_fmt_command = "goimports"

  " Completion
  " Plug 'ervandew/supertab'
  Plug 'Shougo/deoplete.nvim'
  Plug 'zchee/deoplete-go', { 'do': 'make'}
  set previewheight=1
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#sources#go#align_class = 1
  let g:deoplete#enable_ignore_case = 'ignorecase'
  let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
  " let g:deoplete#sources = {}
  " let g:deoplete#sources_ = ['buffer','tag']
  " let g:deoplete#sources#go#gocode_binary = '/path/to/gocode'
  inoremap <silent><expr> <Tab>
              \ pumvisible() ? "\<C-n>" :
              \ deoplete#mappings#manual_complete()
  inoremap <expr><C-h>
              \ deoplete#mappings#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>
              \ deoplete#mappings#smart_close_popup()."\<C-h>"
  set completeopt+=noinsert
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " CtrlP
  Plug 'kien/ctrlp.vim'
  Plug 'tacahiroy/ctrlp-funky'
  set runtimepath^=~/.nvim/plugged/ctrlp.vim
  let g:ctrlp_max_depth=40
  let g:ctrlp_max_files=0
  let g:ctrlp_working_path_mode=0
  let g:ctrlp_switch_buffer=0
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
  " nmap <Leader>r :CtrlPMRU<Cr>
  nmap <Leader>c :CtrlPClearCache<Cr>
  " nmap <Leader>b :CtrlPBuffer<Cr>
  nnoremap <Leader>d :CtrlPFunky<Cr>
  " narrow the list down with a word under cursor
  nnoremap <Leader>D :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

  " Color Schemes
  Plug 'Lokaltog/vim-distinguished'
  Plug 'altercation/vim-colors-solarized'
  Plug 'https://github.com/gilgigilgil/anderson.vim'
  Plug 'tomasr/molokai'
  Plug 'AlessandroYorba/Alduin'
  " Plug 'mhartington/oceanic-next'
  " Plug 'freeo/vim-kalisi'

  " Airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
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
  let g:airline_theme = 'murmur'
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
  let g:airline#extensions#syntastic#enabled = 0
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_tab_type = 0
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''
  let g:airline#extensions#tabline#right_sep = ''
  let g:airline#extensions#tabline#right_alt_sep = ''
  let g:airline#extensions#tabline#close_symbol = '╳'

  " FZF
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  Plug 'junegunn/fzf.vim'
  " let g:fzf_layout = { 'window': 'enew' }
  " let fzf_command = '((git ls-files && git ls-files --exclude-standard --cached --others 2> /dev/null)'  " git
  " let fzf_command .= ' || (hg manifest --all 2> /dev/null)'  " mercurial
  " let fzf_command .= ' || (bzr ls --versioned --recursive 2> /dev/null)'  " bzr
  " let fzf_command .= ' || (find -type d -name ".svn" -prune -o \( -type f -o -type l \) -print | cut -c3-)) | sort | uniq'  " svn and normal directories
  " let $FZF_DEFAULT_COMMAND=fzf_command
  if executable('ag')
      let $FZF_DEFAULT_COMMAND='ag -l -g ""'
      nnoremap <silent> <Leader>a :Ag<Cr>
  else
      nnoremap <silent> <Leader>a :echo "'ag' is not installed."<Cr>
  endif
  nnoremap <silent> <Leader>f :Files<Cr>
  nnoremap <silent> <Leader>r :History<Cr>
  nnoremap <silent> <Leader>b :Buffers<Cr>

  " UltiSnips
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir = $HOME.'/.nvim/UltiSnips'
  let g:UltiSnipsExpandTrigger="<F3>"
  let g:UltiSnipsListSnippets="<F6>"
  let g:UltiSnipsJumpForwardTrigger="<c-k>"
  let g:UltiSnipsJumpBackwardTrigger="<c-j>"

  " undotree
  Plug 'mbbill/undotree'
  nnoremap <leader>u :UndotreeToggle<cr>

  " Fugitive
  " nnoremap <leader>gs :Gstatus<cr>
  " nnoremap <leader>gd :Gdiff<cr>
  " nnoremap <leader>gb :Gblame<cr>
  " nnoremap <leader>gw :Gwrite
  " nnoremap <leader>gr :Gread
  " nnoremap <leader>dp :diffput<cr>:diffupdate<cr>
  " vnoremap <leader>dp :diffput<cr>:diffupdate<cr>
  " nnoremap <leader>dg :diffget<cr>:diffupdate<cr>
  " vnoremap <leader>dg :diffget<cr>:diffupdate<cr>
  Plug 'tpope/vim-fugitive'

  call plug#end()
endfunction

call VimrcLoadPlugins()

" Global Settings
filetype indent plugin on                          " turn on plugins
syntax enable                                      " syntax highlighting on
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
" set list listchars=tab:»·,trail:·,extends:>,nbsp:_ " visually display whitespace
set nowrap                                         " allow visual wrapping
set relativenumber                                 " relative numbering sidebar
set showcmd                                        " shows current cmd combo
set noerrorbells                                   " disables error bell
set virtualedit=all                                " allows arbitrary cursor pos
set undodir=~/.vim/undo,.
set undofile
nnoremap j gj
nnoremap k gk
" select last pasted (changed) text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nmap <Leader>- :tabmove -1<cr>
nmap <Leader>+ :tabmove +1<cr>
nmap <Leader>= :%s/<[^>]*>/\r&\r/g<cr>:%g/^$/d<cr>:normal ggVG=<cr>
set hlsearch                                       " highlight searches
nmap <F1> :echo "Stop pressing esc in normal mode"<CR>
imap <F1> <Esc>
nmap <silent> <Leader>h :nohlsearch<cr>

" Formatting -- based on graywh
set formatoptions=
set formatoptions+=r  " Continue comments by default
set formatoptions+=o  " Make comment when using o or O from comment line
set formatoptions+=q  " Format comments with gq
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=2  " Use indent from 2nd line of a paragraph
set formatoptions+=l  " Don't break lines that are already long
set formatoptions+=c  " Format comments
set formatoptions+=t  " Wrap when using textwidth
set formatoptions+=1  " Break before 1-letter words
set formatoptions+=j  " Remove comment characters when joining lines
set formatlistpat=^\\s*\\(\\d\\+\\\|\\*\\\|-\\\|•\\)[\\]:.)}\\t\ ]\\s*

" Colorscheme
set t_Co=256
" In case t_Co alone doesn't work, add this as well:
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
colorscheme distinguished
set background=dark
set fillchars+=vert:│
" Highlight color customizations
highlight NonText ctermfg=darkgray  guifg=darkgray
highlight SpecialKey ctermfg=darkgray guifg=darkgray
highlight TermCursor ctermfg=red guifg=red
highlight VertSplit ctermfg=3 ctermbg=0
highlight NonText ctermfg=0
highlight Conceal ctermbg=none ctermfg=163 cterm=bold

" Language-specific tweaks
autocmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType jsp imap </ </<C-X><C-O><C-[><<
autocmd FileType jsp setl ts=2 sw=2 sts=2
autocmd FileType javascript setl omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript setl colorcolumn=81
autocmd FileType javascript setl ts=4 sw=4 sts=4
autocmd FileType javascript.jsx setl ts=2 sw=2 sts=2
autocmd FileType c setl omnifunc=ccomplete#Complete
autocmd FileType java setl ts=2 sw=2 sts=2
" autocmd FileType go setl list listchars=tab:\ \ ,trail:·,extends:>,nbsp:_
autocmd FileType go setl colorcolumn=81 foldmethod=syntax foldnestmax=1 noexpandtab
autocmd FileType css setl omnifunc=csscomplete#CompleteCSS
autocmd FileType python setl omnifunc=pythoncomplete#Complete
autocmd FileType xml setl omnifunc=xmlcomplete#CompleteTags
autocmd FileType typescript setl colorcolumn=81

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

" Grep / Ag Integration
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
" Grep for word under cursor
nnoremap <Leader>t :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Keybind to replace visual selection with something
vnoremap <C-r> "hy:%s;<C-r>h;;gc<left><left><left>

" Some important top-level remaps
imap <BS> <C-H>
cmap W<cr> up<cr>
nmap <Space> 1<C-D>
nmap ; 1<C-U>
noremap <ScrollWheelUp> 1<C-D>
noremap <ScrollWheelDown> 1<C-U>
inoremap <ScrollWheelUp> 1<C-D>
inoremap <ScrollWheelDown> 1<C-U>
" nmap <C-L> zl
" nmap <C-H> zh

" Window split settings
set splitbelow
set splitright

" Terminal settings
tnoremap <Leader><ESC> <C-\><C-n>

" Window navigation function
" Make ctrl-h/j/k/l move between windows and auto-insert in terminals
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor

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

" Workspace Setup
" ----------------
function! DefaultWorkspace()
    " Rough num columns to decide between laptop and big monitor screens
    let numcol = 2
    if winwidth(0) >= 220
        let numcol = 3
    endif

    if numcol == 3
        e term://zsh
        file Shell\ Two
        vnew
    endif

    vsp term://~/Programs/golang/context
    file Context
    sp term://zsh
    file Shell\ One
    wincmd k
    resize 4
    set wfh
    wincmd h
endfunction
command! -register DefaultWorkspace call DefaultWorkspace()

function! ElephantronWorkspace()
  call DefaultWorkspace()

  for i in [1, 2, 3, 4]
    wincmd l
    wincmd j
  endfor

  above sp term://zsh
  file Shell\ Alpha
  resize 8
  set wfh

  for i in [1, 2, 3, 4]
    wincmd l
    wincmd j
  endfor

  above sp term://zsh
  file Shell\ Beta
  resize 8
  set wfh
endfunction
command! -register ElephantronWorkspace call ElephantronWorkspace()

" Copy all matched strings
" ------------------------
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" Location list loop function
" ---------------------------
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

" Auto Add Modeline
" -----------------
" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.': '
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Load Official matchit.vim
" -------------------------
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Equal Programs
" --------------
if executable('xmllint') == 1
  autocmd FileType xml let &l:equalprg='xmllint --format --recover -'
endif

if executable('tidy') == 1
  autocmd FileType html let &l:equalprg='tidy -quiet --indent yes --show-errors 0'
endif

" vim-textobj-user
" ----------------
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


" quick-scope
" -----------
" Insert into your .vimrc after quick-scope is loaded.
" Obviously depends on <https://github.com/unblevable/quick-scope> being installed.
function! Quick_scope_selective(movement)
    let needs_disabling = 0
    if !g:qs_enable
        QuickScopeToggle
        redraw
        let needs_disabling = 1
    endif

    let letter = nr2char(getchar())

    if needs_disabling
        QuickScopeToggle
    endif

    return a:movement . letter
endfunction

let g:qs_enable = 0

nnoremap <expr> <silent> f Quick_scope_selective('f')
nnoremap <expr> <silent> F Quick_scope_selective('F')
nnoremap <expr> <silent> t Quick_scope_selective('t')
nnoremap <expr> <silent> T Quick_scope_selective('T')
vnoremap <expr> <silent> f Quick_scope_selective('f')
vnoremap <expr> <silent> F Quick_scope_selective('F')
vnoremap <expr> <silent> t Quick_scope_selective('t')
vnoremap <expr> <silent> T Quick_scope_selective('T')
