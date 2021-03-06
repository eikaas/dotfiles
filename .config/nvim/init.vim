set encoding=utf-8
scriptencoding utf-8

function! EnsureVimPlug(vimplug)
	if !filereadable(a:vimplug)
		echo 'vim-plug: Downloading junegunn/vim-plug..'
		silent !\curl -SLfo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		return 1
	endif
endfunction

function! RunPlugInstall(condition)
	if a:condition
		echo 'vim-plug: Installing plugins..'
    augroup startvim
      !autocmd
      autocmd VimEnter * PlugInstall
    augroup END
	endif
endfunction

call plug#begin('~/.local/share/nvim/plugged')
Plug 'cespare/vim-toml'
Plug 'ekalinin/Dockerfile.vim', { 'for' : 'Dockerfile'}
Plug 'elzr/vim-json',{ 'for' : 'json'}
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'fatih/vim-nginx' , { 'for' : 'nginx'}
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'plasticboy/vim-markdown'
Plug 'mattn/webapi-vim'
Plug 'mattn/vim-gist'
Plug 'vim-syntastic/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tyru/open-browser.vim'
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/Colorizer'
Plug 'gerw/vim-HiLinkTrace'
call plug#end()
call RunPlugInstall(EnsureVimPlug(expand('~/.local/share/nvim/site/autoload/plug.vim')))
 
filetype off
filetype plugin indent on
set ttyfast
set laststatus=2
set autoread                   " Automatically reread changed files without asking me anything
set autoindent                  
set backspace=indent,eol,start " Makes backspace key more powerful.
set incsearch                  " Shows the match while typing
set hlsearch                   " Highlight found searches
set noerrorbells               " No beeps
set number                     " Show line numbers
set showcmd                    " Show me what I'm typing
set noswapfile                 " Don't use swapfile
set nobackup                   " Don't create annoying backup files
set splitright                 " Split vertical windows right to the current windows
set splitbelow                 " Split horizontal windows below to the current windows
set autowrite                  " Automatically save before :next, :make etc.
set hidden
set fileformats=unix,dos,mac   " Prefer Unix over Windows over OS 9 formats
set noshowmatch                " Do not show matching brackets by flickering
set noshowmode                 " We show the mode with airline or lightline
set ignorecase                 " Search case insensitive...
set smartcase                  " ... but not it begins with upper case
set completeopt=menu,menuone
set nocursorcolumn             " speed up syntax highlighting
set nocursorline
set updatetime=100
set pumheight=10               " Completion window max size
set conceallevel=2             " Concealed text is completely hidden
set shortmess+=c               " Shut off completion messages
set belloff+=ctrlg             " If Vim beeps during completion
set lazyredraw
set wildmenu
set wildmode=full

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('clipboard') 
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif
set maxmempattern=20000
set viminfo='1000

if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
  if !isdirectory($HOME . '/.cache/vim')
    call mkdir($HOME . '/.cache/vim')
  endif
endif

" color
if has('termguicolors')
 set termguicolors
endif
syntax enable
colorscheme dracula

augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
  autocmd BufNewFile,BufRead *.hcl setf conf
  autocmd BufNewFile,BufRead *.tmpl set noet ts=2 sw=2 filetype=gotexttmpl
  autocmd BufNewFile,BufRead *.gohtml set noet ts=2 sw=2 filetype=gotexttmpl
  autocmd BufNewFile,BufRead *.gotmpl set noet ts=2 sw=2 filetype=gotexttmpl
  autocmd BufNewFile,BufRead *.ino setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.md setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.html setlocal noet ts=2 sw=2
  autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.hcl setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.proto setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType help wincmd L
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
augroup END

"===================== STATUSLINE ====================
let s:modes = {
      \ 'n': 'NORMAL', 
      \ 'i': 'INSERT', 
      \ 'R': 'REPLACE', 
      \ 'v': 'VISUAL', 
      \ 'V': 'V-LINE', 
      \ "\<C-v>": 'V-BLOCK',
      \ 'c': 'COMMAND',
      \ 's': 'SELECT', 
      \ 'S': 'S-LINE', 
      \ "\<C-s>": 'S-BLOCK', 
      \ 't': 'TERMINAL'
      \}

let s:prev_mode = ''
function! StatusLineMode()
  let cur_mode = get(s:modes, mode(), '')

  " do not update higlight if the mode is the same
  if cur_mode == s:prev_mode
    return cur_mode
  endif

  if cur_mode ==# 'NORMAL'
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=148 ctermfg=22'
  elseif cur_mode ==# 'INSERT'
    exe 'hi! myModeColor cterm=bold ctermbg=23 ctermfg=231'
  elseif cur_mode ==# 'VISUAL' || cur_mode ==# 'V-LINE' || cur_mode ==# 'V_BLOCK'
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=208 ctermfg=88'
  endif

  let s:prev_mode = cur_mode
  return cur_mode
endfunction

function! StatusLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! StatusLinePercent()
  return (100 * line('.') / line('$')) . '%'
endfunction

function! StatusLineLeftInfo()
 let branch = fugitive#head()
 let filename = '' !=? expand('%:t') ? expand('%:t') : '[No Name]'
 if branch !=# ''
   return printf('%s | %s', branch, filename)
 endif
 return filename
endfunction

exe 'hi! myInfoColor ctermbg=240 ctermfg=252'

" start building our statusline
set statusline=

" mode with custom colors
set statusline+=%#myModeColor#
set statusline+=%{StatusLineMode()}               
set statusline+=%*

" left information bar (after mode)
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineLeftInfo()}
set statusline+=\ %*

" go command status (requires vim-go)
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*

" right section seperator
set statusline+=%=

" filetype, percentage, line number and column number
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineFiletype()}\ %{StatusLinePercent()}\ %l:%v
set statusline+=\ %*

" Syntastics info
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


"===================== MAPPINGS ======================
let mapleader = ' '
map <C-n> :cn<CR>
map <C-m> :cp<CR>
nnoremap <leader>a :cclose<CR>:lclose<cr>

" put quickfix window always to the bottom
augroup quickfix
    autocmd!
    autocmd FileType qf wincmd J
    autocmd FileType qf setlocal wrap

    " Enter automatically into the files directory
    autocmd BufEnter * silent! lcd %:p:h

    " Automatically resize screens to be equally the same
    autocmd VimResized * wincmd =

augroup END

" Fast saving
nnoremap <leader>w :w!<cr>
nnoremap <silent> <leader>q :q!<CR>

" Center the screen
nnoremap <leader> zz

" open vim config
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

"open my cookbook
nnoremap <leader>vh <C-w><C-v><C-l>:e ~/notes/vim-cookbook.md<cr>

" source vim config
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>gl :Gist -l<CR>
nnoremap <leader>gp :Gist -P<CR>

" jump to the next error
" nnoremap <C-e> :cnext<cr>
nnoremap <C-e> :lnext<cr>
nnoremap <C-p> :lprev<cr>
nnoremap <C-p> :lclose<cr>

" echo the number under the cursor as binary, useful for bitwise operations
function! s:echoBinary()
  echo printf('%08b', expand('<cword>'))
endfunction
nnoremap <silent> gb :<C-u>call <SID>echoBinary()<CR>

" echo the number under the cursor as hex
function! s:echoHex()
  echo printf('0x%04X', expand('<cword>'))
endfunction
nnoremap <silent> gh :<C-u>call <SID>echoHex()<CR>

" Source the current Vim file
nnoremap <leader>pr :Runtime<CR>

" Close all but the current one
nnoremap <leader>o :only<CR>

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

" Print full path
map <C-f> :echo expand("%:p")<cr>

" fixes some annoyances
command! Q q
command! W w
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nnoremap <leader><Right> :tabnext<CR><CR>
nnoremap <leader><Left> :tabprev<CR><CR>

nnoremap <leader>t :tabnew<cr>
nnoremap <leader>n :tabnext<cr>
nnoremap <leader>p :tabprev<cr>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Exit on j
imap jj <Esc>

nnoremap <F6> :setlocal spell! spell?<CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when moving up and down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Remap H and L (top, bottom of screen to left and right end of line)
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" Act like D and C
nnoremap Y y$

" Do not show stupid q: window
map q: :q

" Don't move on *
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" mimic the behavior of /%Vfoobar which searches within the previously
" selected visual selection
" while in search mode, pressing / will do this
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
if !has('gui_running')
  set notimeout
  set ttimeout
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" ==================== Fugitive ====================
vnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gs :Gstatus<CR>

" ==================== vim-go ====================
let g:go_fmt_command = 'goimports'
let g:go_list_type = 'quickfix'
let g:go_auto_type_info = 1
let g:go_auto_sameids = 0
let g:go_echo_command_info = 1
let g:go_metalinter_command = 'gopls'
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'deadcode']
let g:go_gopls_staticcheck = 1
let g:go_diagnostics_enabled = 1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_highlight_space_tab_error = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_gocode_propose_source = 1
let g:go_modifytags_transform = 'camelcase'
"let g:go_fold_enable = ['block', 'varconst']
let g:go_fold_import = 1
let g:go_fold_varconst = 1
let g:go_fold_block = 1

nmap <C-g> :GoDecls<cr>
imap <C-g> <esc>:<C-u>GoDecls<cr>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go
  autocmd!
  autocmd FileType go nmap <silent> <C-g> :GoDecls<CR>
  autocmd FileType go imap <silent> <C-g> <esc>:<C-u>GoDecls<cr>
  autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
  autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)
  autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)
  autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  autocmd FileType go nmap <silent> <Leader>b  :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <silent> <Leader>r  <Plug>(go-run)
  autocmd FileType go nmap <silent> <Leader>e  <Plug>(go-install)
  autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)
augroup END

let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

" ==================== NerdTree ====================
noremap <Leader><tab> :NERDTreeToggle<cr>
noremap <Leader><F3> :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" ==================== markdown ====================
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_conceal = 0
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

let g:vim_json_syntax_conceal = 0

" ==================== Completion + Snippet ====================
" Ultisnips has native support for SuperTab. SuperTab does omnicompletion by
" pressing tab. I like this better than autocompletion, but it's still fast.
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

" ==================== git-gutter ====================
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '¿'
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0

if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

nnoremap <leader>1 :GitGutterLineHighlightsToggle<CR>

" vipga=
xmap ga <Plug>(EasyAlign)
" gaip=
nmap ga <Plug>(EasyAlign)

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_vim_checkers = ['vint']
let g:gist_detect_filetype = 1
let g:gist_post_private = 1

if has('mac') 
  let g:gist_clip_command = 'pbcopy'
elseif has('unix')
  let g:gist_clip_command = 'xsel --clipboard --input'
endif

highlight SyntasticErrorLine guibg=#9f0000 
highlight SyntasticWarnLine guibg=#6f4a00

" ==================== Folding ====================
highlight Folded guibg=#272A35 guifg=#5F7389
set foldmethod=syntax
set foldnestmax=1

" Provide information about the syntax highlighting under the cursor
map <leader>hl <Plug>HiLinkTrace

" vim: sw=2 sw=2 et
