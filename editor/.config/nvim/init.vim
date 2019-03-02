" Fish doesn't play all that well with others
set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================
" Load vundle
set nocompatible
filetype off
set rtp+=~/dev/others/base16/vim/
call plug#begin()

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'vim-scripts/localvimrc'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
"Plug 'phildawes/racer'
"Plug 'racer-rust/vim-racer'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" Completion plugins
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
"Plug 'fatih/vim-go'
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end

if !has('gui_running')
  set t_Co=256
endif

" Plugin settings
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

" Base16
let base16colorspace=256
let g:base16_shell_path="~/dev/others/base16/shell/scripts/"

" Lightline
" let g:lightline = { 'colorscheme': 'wombat' }
let g:lightline = {
      \ 'active': {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'readonly', 'filename', 'modified' ] ],
      \  'right': [
      \             ['teststatus'], ['lineinfo'],
      \             ['percent'], ['fileformat', 'fileencoding', 'filetype']
      \           ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'teststatus': 'TestStatus',
      \ },
\ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Javascript
let javaScript_fold=0

" Linter
" only lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_all_targets = 1

" language server protocol
" work around the lack of a global language client settings file:
" https://github.com/rust-lang/rls/issues/1324
" https://github.com/autozimu/LanguageClient-neovim/issues/431
" I primarily want that for the ability to set `build_on_save`,
" which I in turn want because of
" https://github.com/autozimu/LanguageClient-neovim/issues/603
let g:LanguageClient_settingsPath = expand('~/.config/nvim/settings.json')
let g:LanguageClient_serverCommands = {
    \ 'rust': ['env', 'CARGO_TARGET_DIR=/data/jon/cargo-target/rls', 'rls'],
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
" don't make errors so painful to look at
let g:LanguageClient_diagnosticsDisplay = {
    \     1: {
    \         "name": "Error",
    \         "texthl": "ALEError",
    \         "signText": "✖",
    \         "signTexthl": "ErrorMsg",
    \         "virtualTexthl": "WarningMsg",
    \     },
    \     2: {
    \         "name": "Warning",
    \         "texthl": "ALEWarning",
    \         "signText": "⚠",
    \         "signTexthl": "ALEWarningSign",
    \         "virtualTexthl": "Todo",
    \     },
    \     3: {
    \         "name": "Information",
    \         "texthl": "ALEInfo",
    \         "signText": "ℹ",
    \         "signTexthl": "ALEInfoSign",
    \         "virtualTexthl": "Todo",
    \     },
    \     4: {
    \         "name": "Hint",
    \         "texthl": "ALEInfo",
    \         "signText": "➤",
    \         "signTexthl": "ALEInfoSign",
    \         "virtualTexthl": "Todo",
    \     },
    \ }

" Latex
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" Don't confirm .lvimrc
let g:localvimrc_ask = 0

" racer + rust
" https://github.com/rust-lang/rust.vim/issues/192
let g:rustfmt_command = "rustfmt +nightly"
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'
"let g:racer_cmd = "/usr/bin/racer"
"let g:racer_experimental_completer = 1
let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" Completion
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" tab to select
" and don't hijack my enter key
inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" Golang
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_bin_path = expand("~/dev/go/bin")

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  " screen does not (yet) support truecolor
  set termguicolors
endif
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Settings needed for .lvimrc
set exrc
set secure

" Sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Use wide tabs
set shiftwidth=8
set softtabstop=8
set tabstop=8
set noexpandtab

" Get syntax
syntax on

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
set nofoldenable
set ruler " Where am I?
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers
set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set colorcolumn=80 " and give me a colored column
set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.

" Colors
set background=dark
colorscheme base16-atelier-dune
hi Normal ctermbg=NONE

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set nolist
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" =============================================================================
" # Keyboard shortcuts
" =============================================================================
" ; as :
nnoremap ; :

" Ctrl+c and Ctrl+j as Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Suspend with Ctrl+f
inoremap <C-f> :sus<cr>
vnoremap <C-f> :sus<cr>
nnoremap <C-f> :sus<cr>

" Jump to start and end of line using the home row keys
map H ^
map L $

" Neat X clipboard integration
" ,p will paste clipboard into buffer
" ,c will copy entire buffer into clipboard
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" <leader>s for Rg search
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', expand('%'))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)


" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" Jump to next/previous error
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
nmap <silent> L <Plug>(ale_lint)
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)
nnoremap <C-l> :copen<cr>
nnoremap <C-g> :cclose<cr>

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>= reformats current tange
nnoremap <leader>= :'<,'>RustFmtRange<cr>

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct_
noremap <leader>n ct-

" M to make
noremap M :!make -k -j4<cr>

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>


" =============================================================================
" # Autocommands
" =============================================================================

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Auto-make less files on save
autocmd BufWritePost *.less if filereadable("Makefile") | make | endif

" Follow Rust code style rules
au Filetype rust source ~/.config/nvim/scripts/spacetab.vim
" Highlight the excess characters
au FileType rust highlight rightMargin ctermbg=233
au FileType rust 2match rightMargin /.\%>100v/

" Help filetype detection
autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.lds set filetype=ld
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.trm set filetype=c
autocmd BufRead *.xlsx.axlsx set filetype=ruby

" Script plugins
autocmd Filetype html,xml,xsl,php source ~/.config/nvim/scripts/closetag.vim

" =============================================================================
" # Footer
" =============================================================================

" nvim
if has('nvim')
	runtime! plugin/python_setup.vim
endif

" =============================================================================
" # HILIGHT CURRENT WORD
" =============================================================================
setl updatetime=200
highlight currentWordHi term=bold ctermbg=236 guibg=green
au CursorHold * exe 'match currentWordHi /\V\<'.substitute(escape(expand('<cword>'),'\'),"/","\\\\/","g").'\>/'
au CursorHoldI * exe 'match currentWordHi /\V\<'.substitute(escape(expand('<cword>'),'\'),"/","\\\\/","g").'\>/'

" =============================================================================
" # RUN TESTS IN BACKGROUND
" =============================================================================
let g:TestStatus=-1
function! TestStatus()
  if &filetype != "rust"
    return ""
  elseif g:TestStatus == -1
    return "[Test: N/A]"
  elseif g:TestStatus == 0
    return "[Test: OK.]"
  else
    return "[Test: ERR]"
  endif
endfunction
function! s:BgCmdCB(job_id, data, event)
    call writefile([join(a:data)], g:bgCmdOutput, 'a')
endfunction
function! s:BgCmdExit(job_id, data, status)
  let l:bufno = bufwinnr("__Bg_Res__")
  echo 'Running' g:bgCmd 'in background... Done.'
  let g:TestStatus=a:data
  " Change status line to show errors
  if a:data > 0
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
    if l:bufno == -1
      below 8split __Bg_Res__
      let l:bufno = bufwinnr("__Bg_Res__")
    else
      execute bufno . "wincmd w"
    endif
    normal! ggdG
    setlocal buftype=nofile
    call append(0,readfile(g:bgCmdOutput))
    normal! gg
    execute "-1 wincmd w"
  else
    " Restore status line
    hi statusline term=bold,reverse cterm=bold ctermfg=233 ctermbg=66 gui=bold guifg=#1c1c1c guibg=#5f8787
    " Close tests result window
    if l:bufno != -1
      execute bufno . "wincmd w"
      close
    endif
  endif
  unlet g:bgCmdOutput
endfunction

function! RunBgCmd(command)
  let g:bgCmd = a:command
  if exists('g:bgCmdOutput')
    echo 'Task' g:bgCmd 'running in background'
  else
    echo 'Running' g:bgCmd 'in background'
    let g:bgCmdOutput = tempname()
    call jobstart(a:command,{
      \'on_stderr': function('s:BgCmdCB'),
      \'on_stdout': function('s:BgCmdCB'),
      \'on_exit': function('s:BgCmdExit')})
  endif
endfunction

command! -nargs=+ -complete=shellcmd RunBg call RunBgCmd(<q-args>)
autocmd FileType rust nmap <leader>tc :RunBg cargo test<CR>
autocmd FileType rust nmap <leader>tC :RunBg cargo test -- --nocapture<CR>

