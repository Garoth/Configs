function! VimrcLoadPlugins()
  let g:vim_plug_dir = $HOME.'/.config/nvim'

  " Install vim-plug if not available
  if !isdirectory(g:vim_plug_dir)
    call mkdir(g:vim_plug_dir, 'p')
  endif
  if !filereadable(g:vim_plug_dir.'/autoload/vim-plug/plug.vim')
    execute '!git clone git@github.com:junegunn/vim-plug.git '
          \ shellescape(g:vim_plug_dir.'/autoload/vim-plug/', 1)
  endif

  " Starting plugin setup
  call plug#begin()

  " Dep Libs
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'MunifTanjim/nui.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-tree/nvim-web-devicons' " req by: markview

  " Misc
  Plug 'Raimondi/delimitmate' " auto close parens and stuff
  Plug 'ap/vim-css-color' " maybe works
  Plug 'groenewege/vim-less' " less support, maybe outdated
  Plug 'guns/xterm-color-table.vim' " just cute color table
  Plug 'honza/vim-snippets' " generic snippet collection
  Plug 'jakar/vim-AnsiEsc' " maybe conseals escape codes
  Plug 'nanozuki/tabby.nvim' " tab workspaces
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'tommcdo/vim-exchange' " swap stuff cx<motion>
  Plug 'tpope/vim-commentary' " gc commenting
  Plug 'tpope/vim-eunuch' " filesystem :Move and them
  Plug 'tpope/vim-surround' " changing surrounding cs, ds
  Plug 'tomlion/vim-solidity' " syntax for solidity
  Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
  Plug 'dhruvasagar/vim-table-mode' " TableModeToggle \tm
  Plug 'stevearc/oil.nvim' " sweet filesystem editor
  Plug 'mistricky/codesnap.nvim', { 'do': 'make' } " screenshots
  Plug 'OXY2DEV/markview.nvim'
  Plug 'uga-rosa/ccc.nvim'
  Plug 'samjwill/nvim-unception'

  " Language server stuff
  Plug 'neovim/nvim-lspconfig'
  Plug 'weilbith/nvim-lsp-smag'

  " Dart / Flutter
  Plug 'dart-lang/dart-vim-plugin'
  let g:dart_format_on_save = v:true
  Plug 'thosakwe/vim-flutter'
  Plug 'natebosch/vim-lsc'
  Plug 'natebosch/vim-lsc-dart'

  " Live Package Version Info
  Plug 'meain/vim-package-info', { 'do': 'npm install' }
  let g:vim_package_info_virutaltext_highlight = 'VimPackageInfoText'

  " Plugins written by me
  " Plug 'Garoth/fix-copied-url.nvim'

  " Highlighted yank
  Plug 'machakann/vim-highlightedyank'
  map y <Plug>(highlightedyank)

  " FastFold & vim-stay
  " Plug 'Konfekt/FastFold'
  " Plug 'kopischke/vim-stay'
  " set viewoptions=cursor,folds,slash,unix

  " vim-javascript
  Plug 'pangloss/vim-javascript'
  let g:javascript_conceal_function   = "f"
  let g:javascript_conceal_null       = "Π"
  let g:javascript_conceal_this       = "@"
  let g:javascript_conceal_return     = "⇚"
  let g:javascript_conceal_undefined  = "¿"
  let g:javascript_conceal_NaN        = "ℕ"
  let g:javascript_conceal_prototype  = "¶"
  set conceallevel=1
  let g:javascript_plugin_flow        = 1

  " React / JSX support
  Plug 'MaxMEllon/vim-jsx-pretty'

  " Prettify JS
  Plug 'prettier/vim-prettier', {
          \ 'do': 'yarn install',
          \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'vue', 'svelte', 'yaml', 'html'] }
  let g:prettier#autoformat = 1
  let g:prettier#autoformat_require_pragma = 0
  let g:prettier#exec_cmd_async = 1

  " Neomake
  let g:neomake_open_list = 0
  let g:neomake_list_height = 1
  let g:neomake_echo_current_error = 1
  let g:neomake_javascript_enabled_makers = ['eslint']
  Plug 'neomake/neomake'
  Plug 'benjie/neomake-local-eslint.vim'
  autocmd! BufWritePost * Neomake

  " Tabular
  Plug 'godlygeek/tabular'
  " nmap <Leader>a, :Tabularize /,\zs<CR>
  Plug 'preservim/vim-markdown' " must be after Tabular
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_toml_frontmatter = 1
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_strikethrough = 1

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
  set completeopt-=preview

  " Deoplete
  Plug 'Shougo/deoplete.nvim'
  Plug 'deoplete-plugins/deoplete-lsp'
  Plug 'zchee/deoplete-go', { 'do': 'make'}
  " prob need: go install github.com/nsf/gocode
  set previewheight=1
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#sources#go#align_class = 1
  let g:deoplete#enable_ignore_case = 'ignorecase'
  let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()
  " inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
  " inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
  set completeopt+=noinsert
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Deoplete Flow Integration
  Plug 'steelsojka/deoplete-flow'
  function! StrTrim(txt)
      return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
  endfunction
  let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
  if g:flow_path != 'flow not found'
      let g:deoplete#sources#flow#flow_bin = g:flow_path
  endif

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
  " nmap <Leader>c :CtrlPClearCache<Cr>
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
  let g:airline_theme = 'athorp'
  let g:airline_powerline_fonts = 1
  " Arrow character: 
  " Simplify the number area to just be line number, col number
  let g:airline_section_z = "%2l, %2c"
  " Simplify vcs integration to just show branch name
  let g:airline_section_b = "%{airline#util#wrap(airline#extensions#branch#get_head(),0)}"
  if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  " unicode symbols
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.paste = 'ρ'
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
  let g:airline#extensions#whitespace#enabled = 0

  " FZF - install `bat` to get color preview
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'window': 'enew' }
  let g:fzf_nvim_statusline = 0
  if executable('ag')
      let $FZF_DEFAULT_COMMAND='ag -l -g ""'
      nnoremap <silent> <Leader>a :Ag<Cr>
  else
      nnoremap <silent> <Leader>a :echo "'ag' is not installed."<Cr>
  endif
  function! s:open_anything(file)
      let g:system = "linux"
      if g:system == "windows"
          for file in a:file
              execute '!start ' . shellescape(file)
          endfor
      elseif g:system == "linux"
          for file in a:file
              execute '!xdg-open ' . shellescape(file)
          endfor
      endif
  endfunction
  let g:fzf_action = { 'ctrl-o': function('s:open_anything') }
  command! -bang -nargs=? -complete=dir Files
              \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline']}), <bang>0)
  nnoremap <silent> <Leader>f :Files<Cr>
  nnoremap <silent> <Leader>h :History<Cr>
  nnoremap <silent> <Leader>b :Buffers<Cr>

  Plug 'ojroques/nvim-lspfuzzy'

  " UltiSnips
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir = $HOME.'/.nvim/UltiSnips'
  let g:UltiSnipsExpandTrigger="<D-3>"
  let g:UltiSnipsListSnippets="<D-4>"
  let g:UltiSnipsJumpForwardTrigger="<c-k>"
  let g:UltiSnipsJumpBackwardTrigger="<c-j>"

  " undotree
  Plug 'mbbill/undotree'
  nnoremap <leader>g :UndotreeToggle<cr>

  " Fugitive
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
" set lazyredraw                                     " no redraw in macros
set synmaxcol=2000                                 " no syn after 2000
set mouse=                                         " turn off mouse
set shortmess=atTFI                                " shorten messages in prompt
" set list listchars=tab:»·,trail:·,extends:>,nbsp:_ " visually display whitespace
set nowrap                                         " allow visual wrapping
set number                                         " numbering sidebar
set relativenumber                                 " relative numbering sidebar
autocmd TermOpen * setlocal nonumber norelativenumber
set showcmd                                        " shows current cmd combo
set noerrorbells                                   " disables error bell
set nojoinspaces                                   " don't do spacing special cases
set virtualedit=all                                " allows arbitrary cursor pos
set cmdheight=2                                    " to avoid ENTER prompts...
set undodir=~/.vim/undo,.
set undofile
set inccommand=nosplit
set maxmempattern=400000
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

" Highlight color customizations (for distinguished)
" ':Inspect' groups under cursor
highlight NonText ctermfg=darkgray  guifg=darkgray guibg=none ctermbg=none
highlight SpecialKey ctermfg=darkgray guifg=darkgray guibg=none ctermbg=none
highlight VertSplit ctermbg=none ctermfg=3 guibg=none
highlight Conceal ctermbg=none ctermfg=163 cterm=bold
highlight Comment ctermbg=none guibg=none ctermfg=lightblue guifg=lightblue
highlight LineNr ctermbg=none ctermfg=grey guibg=none 
highlight VimPackageInfoMajor ctermfg=160 cterm=bold
highlight VimPackageInfoMinor ctermfg=172 cterm=bold
highlight VimPackageInfoPatch ctermfg=186 cterm=bold
highlight VimPackageInfoText ctermfg=245
highlight TermCursor cterm=reverse gui=reverse
highlight NormalFloat ctermbg=236
highlight Normal ctermbg=none guibg=none
highlight Folded guibg=none ctermbg=none
highlight SignColumn guibg=none ctermbg=none
highlight EndOfBuffer guibg=none ctermbg=none
highlight TabLine guifg=#ffffff ctermfg=231 guibg=#444444 ctermbg=238 
highlight TabLineFill guifg=lightpurple ctermfg=13 guibg=#444444 ctermbg=238
" Markdown Customizations
highlight Title ctermfg=192 cterm=bold
highlight @text.title.1.marker.markdown ctermfg=191 cterm=bold
highlight @text.title.1.markdown ctermfg=191 cterm=bold
highlight @markup.heading.1.markdown ctermfg=191 cterm=bold guifg=lightblue gui=bold
highlight @text.title.2.marker.markdown ctermfg=192 cterm=bold
highlight @text.title.2.markdown ctermfg=192 cterm=bold
highlight @markup.heading.2.markdown ctermfg=192 cterm=bold guifg=lightblue gui=bold
highlight @text.title.3.marker.markdown ctermfg=193 cterm=bold
highlight @text.title.3.markdown ctermfg=193 cterm=bold
highlight @markup.heading.3.markdown ctermfg=193 cterm=bold guifg=lightblue gui=bold
highlight @text.title.4.marker.markdown ctermfg=194 cterm=bold
highlight @text.title.4.markdown ctermfg=194 cterm=bold
highlight @markup.heading.4.markdown ctermfg=194 cterm=bold guifg=lightblue gui=bold
highlight Delimiter ctermfg=240 guifg=darkgrey cterm=bold
highlight @text ctermfg=none
highlight @text.emphasis.markdown_inline ctermfg=none cterm=italic
highlight @text.strong.markdown_inline ctermfg=none cterm=bold
highlight @text.literal.markdown_inline ctermfg=85

" Language-specific tweaks
autocmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType jsp imap </ </<C-X><C-O><C-[><<
autocmd FileType jsp setl ts=2 sw=2 sts=2
autocmd FileType javascript setl omnifunc=v:lua.vim.lsp.omnifunc
autocmd FileType javascript setl colorcolumn=81
autocmd FileType javascript setl ts=4 sw=4 sts=4
autocmd FileType javascript.jsx setl ts=4 sw=4 sts=4 omnifunc=v:lua.vim.lsp.omnifunc
autocmd FileType javascript,javascript.jsx
lua require'lspconfig'.flow.setup{}
autocmd BufWritePost javascript.jsx lua vim.lsp.diagnostic.set_loclist()
autocmd FileType c setl omnifunc=ccomplete#Complete
autocmd FileType java setl ts=2 sw=2 sts=2
" autocmd FileType go setl list listchars=tab:\ \ ,trail:·,extends:>,nbsp:_
autocmd FileType go setl ts=4 sw=4 sts=4 colorcolumn=81 noexpandtab
autocmd FileType css setl omnifunc=csscomplete#CompleteCSS
autocmd FileType python setl omnifunc=pythoncomplete#Complete
autocmd FileType xml setl omnifunc=xmlcomplete#CompleteTags
autocmd FileType typescript setl colorcolumn=81

" Abbreviations
ab !+ !=
ab :+ :=

" Next two commands make vim use system clipboard
set clipboard=unnamedplus
nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamedplus' ? '"*p' : '"' . v:register . 'p')

" Make integration stuff
" map <F2> :Neomake!<cr>
" let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
" autocmd BufEnter $HOME/Programs/uno/* map <buffer> <F2>
"                 \ :NeomakeSh cd $HOME/Programs/uno && $HOME/Programs/uno/scripts/deps.sh<CR>

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

lua << EOF
-- Terminal colors
vim.g.terminal_color_0 = '#003440'
vim.g.terminal_color_1 = '#DC312E'
vim.g.terminal_color_2 = '#859901'
vim.g.terminal_color_3 = '#B58900'
vim.g.terminal_color_4 = '#268AD2'
vim.g.terminal_color_5 = '#D33582'
vim.g.terminal_color_6 = '#2AA197'
vim.g.terminal_color_7 = '#EEE8D5'
vim.g.terminal_color_8 = '#002833'
vim.g.terminal_color_9 = '#CB4A16'
vim.g.terminal_color_10 = '#8DA634'
vim.g.terminal_color_11 = '#C28F2C'
vim.g.terminal_color_12 = '#0692D4'
vim.g.terminal_color_13 = '#6C6EC6'
vim.g.terminal_color_14 = '#00B3A7'
vim.g.terminal_color_15 = '#FDF6E3'

-- GUI configs
vim.opt.guifont = "Maple Mono,Hasklug Nerd Font Mono:h20"
vim.keymap.set('t', '<S-space>', '<space>')

-- Show line diagnostics in a window
vim.o.updatetime = 250 -- global hold time setting
vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'line',
            max_width = 70,
            pad_top = 1,
            pad_bottom = 1,
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

--vim-table-mode - creating markdown compatible tables
vim.g.table_mode_corner = '|'
vim.g.table_mode_header_fillchar = '-' -- header underline
-- color cells: cells must start with yes/no/?
vim.g.table_mode_color_cells = true
vim.api.nvim_set_hl(0, 'yesCell', { fg = vim.g.terminal_color_2, underdashed = true })
vim.api.nvim_set_hl(0, 'maybeCell', { fg = vim.g.terminal_color_11, undercurl = true })
vim.api.nvim_set_hl(0, 'noCell', { fg = vim.g.terminal_color_9, underdouble = true })

if vim.g.neovide then
    vim.g.neovide_scroll_animation_length = 0.25
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_refresh_rate = 30
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_scale_factor = 0.65
    -- TODO)) neovide_fullscreen breaks transparency in wayland, and that's
    -- how you remove the titlebar / do focus mode, but gnome also broke most
    -- of the shell extensions, so now stuff like Unify doesn't work either
    vim.g.neovide_fullscreen = true
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", guibg = "#181818" })

    if vim.g.neovide == true then
        vim.api.nvim_set_keymap("n", "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05<CR>", { silent = true })
        vim.api.nvim_set_keymap("n", "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05<CR>", { silent = true })
        vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
    end

    -- Allow clipboard copy paste in neovim
    vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
    vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
    vim.keymap.set('v', '<D-c>', '"+y') -- Copy
    vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
    vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

    -- Alpha settings & popup window alpha
    local alpha = function()
      return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    -- g:neovide_transparency should be 0 if you want to unify transparency of
    -- content and title bar
    vim.g.neovide_transparency = 0.9
    vim.g.transparency = 0.9
    vim.g.neovide_background_color = "#00151c" .. alpha()
    vim.g.neovide_floating_blur_amount_x = 4.0
    vim.g.neovide_floating_blur_amount_y = 4.0
    vim.opt.winblend = 30
    vim.opt.pumblend = 30
end

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript",
      "css", "dockerfile", "git_rebase", "gitattributes", 
      "gitcommit", "gitignore", "go", "gomod", "gosum", "gowork", "html",
      "http", "jsdoc", "json", "json5", "markdown", "markdown_inline",
      "mermaid", "proto", "python", "regex", "scss", "solidity", "typescript",
      "yaml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

vim.g.firenvim_config = {
    globalSettings = {
        cmdlineTimeout = 1000
    },
    localSettings = {
        ['.*google.*'] = {
            takeover = "never",
            priority = 1,
        },
        ['.*'] = {
            filename = '/tmp/{hostname%32}_{pathname%8}_{selector%8}_{timestamp%32}.{extension}',
            priority = 0,
        },
    }
}
if vim.g.started_by_firenvim == true then
   vim.cmd [[colorscheme delek]]

   vim.g.airline_powerline_fonts = 0
   vim.g.airline_section_c = ''
   vim.g.airline_theme = 'papercolor'

   vim.o.spell = true
   vim.o.wrap = true
   vim.o.linebreak = true
   vim.o.number = false
   vim.o.relativenumber = false

   vim.api.nvim_create_autocmd({'BufEnter'}, {
       pattern = "*flowerpatch.app*",
       command = "set filetype=markdown",
   })

   vim.api.nvim_create_autocmd({'BufEnter'}, {
       pattern = "*reddit.com*",
       command = "set filetype=markdown",
   })
end

require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = false,
  -- Skip the confirmation popup for simple operations
  skip_confirm_for_simple_edits = false,
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  prompt_save_on_select_new_entry = true,
  -- Oil will automatically delete hidden buffers after this delay
  -- You can set the delay to false to disable cleanup entirely
  -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  cleanup_delay_ms = 120000,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    -- ["<C-s>"] = "actions.select_vsplit",
    -- ["<C-h>"] = "actions.select_split",
    -- ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = false,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
    sort = {
      -- sort order can be "asc" or "desc"
      -- see :help oil-columns to see which columns are sortable
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
})

function _G.open_in_new_tab_copy_mode()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd('tabnew')
  vim.api.nvim_win_set_buf(0, bufnr)
  vim.wo.number = false
  vim.wo.relativenumber = false
end

vim.api.nvim_set_keymap('n', '<Leader>p', '<cmd>lua _G.open_in_new_tab_copy_mode()<CR>', { noremap = true, silent = true })

require("codesnap").setup({
    has_breadcrumbs = true,
    breadcrumbs_separator = " ∫ ",
    show_workspace = true,
    bg_theme = "summer",
    watermark = "© Andrei Edell",
    watermark_font_family = "JaneAusten",
    mac_window_bar = true,
})

-- Folds Config
vim.keymap.set('n', 'zp', 'zMzv')

-- Tabby tab bar config
local theme = {
  fill = 'TabLineFill',
  head = 'TabLine',
  current_tab = { fg='#df0087', bg='none' }, -- TabLineSel
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}
local tabname_symbols = {
  '⍜',
  '⌇',
  '☌',
  '⍙',
  '☊',
  '☍',
  '⊑',
}
local name_icons = {
  'αє',
  'αє',
  'αє',
  'αє',
  'αє',
  'αє',
  'αє',
  '👽',
  '👽',
  '👽',
  '👽',
  '👽',
  '👽',
  '👽',
  'ΛΣ',
  '₳Ɇ',
  'À̵̰̠̳Ẹ̶́̍̌͜',
  'A̷̮̟̐ͅE̸̤̋͛',
}
local tab_symbols = {
    start = '',
    stop = '',
    active = '',
    inactive = '󰆣',
    empty = '␢', -- ≋ 〰 ₦
}
local function pretty_buffer_name(name, icon)
  if name == nil then
      name = tab_symbols.empty
  end

  if name == "[No Name]" then
    name = tab_symbols.empty
  end

  local _, _, stripped_name = string.find(name, "%d+:(.*)")
  if stripped_name then
    name = stripped_name
  end

  if string.find(name, "zsh") then
    name = "zsh"
  end

  if icon ~= '' and icon ~= '' then
      name = name .. ' ' .. icon
  end

  return name .. '  '
end
require('tabby').setup({
  line = function(line)
    return {
      {
        { ' ' .. name_icons[math.random(#name_icons)] .. '  ', hl = theme.head },
      },
      line.tabs().foreach(function(tab)
        if tab.is_current() then
          local hl = theme.current_tab
          return {
            line.sep(tab_symbols.start, hl, theme.fill),
            tabname_symbols[tab.number()] or tab.number(),
            line.sep(tab_symbols.stop, hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        else
          local hl = theme.tab
          return {
            line.sep(' ', hl, theme.fill),
            tabname_symbols[tab.number()] or tab.number(),
            line.sep(' ', hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        end
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          win.is_current() and tab_symbols.active or tab_symbols.inactive,
          pretty_buffer_name(win.buf_name(), win.file_icon()),
          hl = theme.win,
          margin = ' ',
        }
      end),
      {
        { '  ', hl = theme.tail },
      },
      hl = theme.fill,
    }
  end,
})

-- Markview
require("markview").setup()

-- Color Picker CCC
vim.opt.termguicolors = true
local ccc = require("ccc")
ccc.setup({
-- Your preferred settings
-- Example: enable highlighter
highlighter = {
    auto_enable = true,
    lsp = true,
    },
})
vim.api.nvim_set_keymap('i', '<Leader>c', '<Plug>(ccc-insert)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>c', '<Plug>(ccc-select-color)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', '<Leader>c', '<Plug>(ccc-select-color)', { noremap = true, silent = true })

-- Generates a floating sudo prompt
function _G.floating_sudo()
  local tmpfile = vim.fn.tempname()
  local filepath = vim.fn.expand('%:p')

  vim.cmd('silent! write ' .. tmpfile)
  local sudo_command = string.format('sudo cp %s %s && echo \'Success\' || echo \'Failure\'', tmpfile, filepath)
  local term_command = string.format([[echo ''
                                      %s && 
                                      echo 'Press any key to close' && 
                                      read -n 1]], sudo_command)

  -- Create the floating window
  local opts = {
    relative = 'editor',
    height = math.ceil(vim.o.lines * 0.4),
    width = math.ceil(vim.o.columns * 0.4),
    row = math.ceil((vim.o.lines - math.ceil(vim.o.lines * 0.4)) / 2),
    col = math.ceil((vim.o.columns - math.ceil(vim.o.columns * 0.4)) / 2),
    style = 'minimal',
    title = '─SUDO WRITE',
    footer = '👽─',
    footer_pos = 'right',
    border = 'single',
    focusable = true,
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Run the terminal command
  vim.fn.termopen(term_command, { on_exit = function()
    -- Close the floating window and buffer when the terminal command exits
    vim.api.nvim_win_close(win, true)
    vim.cmd('bd! ' .. buf)  -- Delete the buffer
    vim.cmd('edit! ' .. filepath)  -- Reload the file
  end })

  -- Switch to insert mode automatically
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_command('startinsert')
end
-- Map the command to the function
vim.api.nvim_set_keymap('c', 'w!!', ':lua floating_sudo()<CR>', { noremap = true, silent = true })


-- LSP Keybinds & idk why I'm using vim-lsc for Dart
local function set_lsp_keybindings(bufnr)
    local keymap_opts = { noremap = true, silent = true }

    -- Set keybindings for LSP commands
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', ':LSClientGoToDefinition<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-W>]', ':LSClientGoToDefinitionSplit<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-W><C-]>', ':LSClientGoToDefinitionSplit<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', ':LSClientFindReferences<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-n>', ':LSClientNextReference<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-p>', ':LSClientPreviousReference<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI', ':LSClientFindImplementations<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', ':LSClientFindCodeActions<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR', ':LSClientRename<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':LSClientShowHover<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'go', ':LSClientDocumentSymbol<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gS', ':LSClientWorkspaceSymbol<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', ':LSClientSignatureHelp<CR>', keymap_opts)

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
end
-- Apply the keybindings immediately for Dart
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dart",
    callback = function(args)
        local bufnr = args.buf
        set_lsp_keybindings(bufnr)
    end,
})
EOF

" Keybind to replace visual selection with something
vnoremap <C-r> "fy:%s;<C-r>f;;gc<left><left><left>

" Some important top-level remaps
imap <BS> <C-H>
cmap W<cr> up<cr>
nmap <Space> 1<C-D>
nmap ; 1<C-U>
noremap <ScrollWheelUp> 1<C-D>
noremap <ScrollWheelDown> 1<C-U>
inoremap <ScrollWheelUp> 1<C-D>
inoremap <ScrollWheelDown> 1<C-U>

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
let s:workspace = "default"
let s:mainwinID = -1 " Reference to the 'middle' window where my main editor is
let s:minwidth = 160
function! NoWorkspace()
    let s:workspace = "none"
endfunction
command! -register NoWorkspace call NoWorkspace()

function! DefaultWorkspace()
    " Default Variables
    let numcol = 2 " Number of columns to use
    let s:mainwinID = -1

    " If the screen is too narrow, just give up. Probably in a split
    if &columns <= s:minwidth
        call NoWorkspace()
        return
    endif

    " If the screen is big enough right now, use three columns
    if &columns >= 240
        let numcol = 3
    endif

    " Custom stuff to add an extra left column if there are 3
    if numcol == 3
        e term://zsh
        vnew
        set wfw
        vertical resize 90
    endif

    " Setting up the right side, with context and terminal
    let s:mainwinID = win_getid()
    vsp term://zsh

    " Custom setup for nugbase-web
    if getcwd() =~ "nugbase-web$"
        let $GOPATH = $PWD . ':' . $GOPATH

        tabnew
        term zsh -c "npm run dev"
        normal G
        let s:firsttermID = win_getid()

        vsp
        " Sleep fixes timing bug
        term zsh -c "sleep 0.25 && npm start -- -flowerpatch"
        normal G

        sp
        " Sleep fixes timing bug
        term zsh -c "sleep 0.25 && FLOWERSCRIPT_DEBUG=TRUE npm run game-server-livity"
        normal G

        sp
        " Sleep fixes timing bug
        term zsh -c "sleep 0.25 && FLOWERSCRIPT_DEBUG=TRUE npm run game-server"
        normal G

        exe win_id2win(s:firsttermID) . "wincmd w"
        sp
        " Sleep fixes timing bug
        term zsh -c "sleep 0.25 && npm run flowerdb-server"
        normal G

        leftabove sp
        " Sleep fixes timing bug
        term zsh -c "sleep 0.25 && source ./scripts/source-me.sh && go run userdb"
        normal G

        normal gT
    endif

    " Select main window
    exe win_id2win(s:mainwinID) . "wincmd w"
endfunction
command! -register DefaultWorkspace call DefaultWorkspace()

" Copy all matched strings
" ------------------------
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" FZF Floating Window
" -------------------
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let opts = {
                \ 'relative': 'editor',
                \ 'row': 4,
                \ 'col': 8,
                \ 'width': &columns - 16,
                \ 'height': &lines - 8
                \ }

    call nvim_open_win(buf, v:true, opts)
endfunction

" Location list loop function
" ---------------------------
function! WrapCommand(direction)
  if a:direction == "up"
    try
      lprevious
    catch /^Vim\%((\a\+)\)\=:E/ 
      try
        llast
      catch /^Vim\%((\a\+)\)\=:E/ 
        echo "No Errors! :-)"
      endtry
    endtry
  elseif a:direction == "down"
    try
      lnext
    catch /^Vim\%((\a\+)\)\=:E/ 
      try
        lfirst
      catch /^Vim\%((\a\+)\)\=:E/ 
        echo "No Errors! :-)"
      endtry
    endtry
  endif
endfunction

nmap <Leader>N :call WrapCommand("up")<CR>
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

" Javascript Custom Commands
" --------------------------
function! JSAlternate()
    if expand("%:e") == "js" || expand("%:e") == "jsx"
        execute "edit " . expand("%:h") . "/" . expand("%:t:r") . ".less"
    elseif expand("%:e") == "less"
        execute "edit " . expand("%:h") . "/" . expand("%:t:r") . ".jsx"
    endif
endfunction
command! -register JSAlternate call JSAlternate()

" Format JSON
" -----------
function! FormatJSON()
    execute "%!python -m json.tool"
endfunction
command! -register FormatJSON call FormatJSON()

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

" Final Startup
au VimEnter * nested call DefaultWorkspace()
