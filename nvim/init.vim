set encoding=utf-8
scriptencoding utf-8
" ===========================================================================
"l  init setting
" ===========================================================================
augroup initvim
  autocmd!
  autocmd BufWritePost $MYVIMRC  source $MYVIMRC | call InitVimrc()
augroup END

function! InitVimrc()
  call LightlineReload()
endfunction

" ===========================================================================
"  Common setting
" ===========================================================================
set noswapfile
set autoread
set autowrite
set ignorecase
set smartcase
set incsearch
set inccommand=split
set scrolloff=10
set keywordprg=:help
set clipboard+=unnamedplus
" set spell
" set spelllang=en,cjk

let g:python3_host_prog = expand("$HOME/.asdf/shims/python3")

set undofile
if !isdirectory(expand("$HOME/.config/nvim/undodir"))
  call mkdir(expand("$HOME/.config/nvim/undodir"), "p")
endif
set undodir=$HOME/.config/nvim/undodir

augroup window_resize
  autocmd!
  autocmd WinEnter * call WinResize()
augroup END

function! WinResize()
  if winwidth('%') < 120
    :vertical resize 120<CR>
  endif
endfunction

" tags setting
set tags=.tags;$HOME
function! s:execute_ctags() abort
  " 探すタグファイル名
  let tag_name = '.tags'
  " ディレクトリを遡り、タグファイルを探し、パス取得
  let tags_path = findfile(tag_name, '.;')
  " タグファイルパスが見つからなかった場合
  if tags_path ==# ''
    return
  endif

  " タグファイルのディレクトリパスを取得
  " `:p:h`の部分は、:h filename-modifiersで確認
  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  " 見つかったタグファイルのディレクトリに移動して、ctagsをバックグラウンド実行（エラー出力破棄）
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction

augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END

" Opening help in a vertical split window
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" ===========================================================================
"  Common Visual setting
" ===========================================================================
set number
" set cursorline
set splitright
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set cmdheight=2

" visualize spaces and tabs
set list
set listchars=tab:>\ ,trail:~,extends:>,precedes:<

" auto highlight current word
" function! HighlightWordUnderCursor()
"     if getline(".")[col(".")-1] !~# '[[:punct:][:blank:]]' 
"         exec 'match' 'Search' '/\V\<'.expand('<cword>').'\>/' 
"     else 
"         match none 
"     endif
" endfunction
" 
" autocmd! CursorHold,CursorHoldI * call HighlightWordUnderCursor()

" ===========================================================================
"  Key Map
" ===========================================================================
let mapleader = "\<Space>"
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
inoremap <silent> jj <ESC>

nnoremap <F1> :OpenSession<CR>
nnoremap <F3> :TagbarToggle<CR>
nnoremap <F5> :vsplit $MYVIMRC<CR>
nnoremap <F7> :PlugInstall<CR>
nnoremap <F8> :PlugUpdate<CR>
nnoremap <F9> :PlugClean<CR>

" FilePath COPY
nnoremap fc :let @* = expand('%')<CR>

" moving window
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L

nnoremap sv <C-w>v
nnoremap ss <C-w>s

nnoremap sq :q<CR>

nnoremap aa <ESC>ggVG<CR>

" for fzf
nnoremap [fzf]   <Nop>
nmap     m       [fzf]
nnoremap [fzf]c :Commands<CR>
nnoremap [fzf]f :GFiles<CR>
nnoremap [fzf]F :GFiles?<CR>
nnoremap [fzf]af :Files<CR>
" nnoremap [fzf]g :Rg <C-r>=expand("<cword>")<CR><CR>
nnoremap [fzf]g :GGrep <C-r><C-w><CR>
nnoremap [fzf]G :GGrep <CR>
nnoremap [fzf]b :Buffers<CR>
nnoremap [fzf]l :BLines<CR>
nnoremap [fzf]h :History<CR>
nnoremap [fzf]H :History:<CR>
nnoremap [fzf]m :Mark<CR>

" for Defx
nnoremap [defx] <Nop>
nmap     <C-e> [defx]
nnoremap [defx]e :Defx<CR>
nnoremap [defx]f :Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>

" ===========================================================================
"  Plugins
" ===========================================================================
call plug#begin('~/.local/share/nvim/plugged')
" Plug 'jceb/vim-orgmode'
Plug 'lifepillar/vim-solarized8', { 'dir': '~/.config/nvim/colors/solarized8' }
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'mechatroner/rainbow_csv'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'mattn/emmet-vim'
Plug 'hyshka/vim-uikit'
Plug 'tpope/vim-surround'
" yank
Plug 'bfredl/nvim-miniyank'
Plug 'ojroques/vim-oscyank'

" Plug 'xavierchow/vim-swagger-preview'

" syntax
Plug 'sheerun/vim-polyglot'
" Plug 'dag/vim-fish'
" Plug 'aklt/plantuml-syntax'
" Plug 'posva/vim-vue'
" Plug 'plasticboy/vim-markdown'
" Plug 'ekalinin/Dockerfile.vim'
" Asynchronous Lint Engine
" Plug 'dense-analysis/ale'

" session
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-session'
" Plug 'ToruIwashita/git-switcher.vim'

" for Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" File Exproler
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'
" for Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
" for Go
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'mattn/vim-goimports'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'ctrlpvim/ctrlp.vim'
" for fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" for LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-necovim.vim'
Plug 'Shougo/neco-vim'
call plug#end()

" ===========================================================================
"  Plugin setting
" ===========================================================================
" color
set termguicolors
set background=dark
syntax enable
colorscheme solarized8_flat
filetype plugin indent on
hi CursorLine term=bold cterm=bold guibg=Grey30

" ---------------------------------------------------------------------------
" for miniyank
" ---------------------------------------------------------------------------
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)

" ---------------------------------------------------------------------------
" for oscyank
" ---------------------------------------------------------------------------
" https://github.com/ojroques/vim-oscyank#copying-from-a-register
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif

" ---------------------------------------------------------------------------
" for plantuml-syntax
" ---------------------------------------------------------------------------
augroup plantuml
  autocmd!
  autocmd FileType plantuml 
	\ autocmd BufWritePost <buffer> silent! :make | silent! :!open %:r.png
augroup END

" ---------------------------------------------------------------------------
"  for lightline.vim
" ---------------------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'selenized_dark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'modified', 'readonly', 'relativepath', 'gitbranch', 'session' ] ]
      \ },
      \ 'component_function': {
      \   'session': 'xolox#session#find_current_session',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

command! LightlineReload call LightlineReload()

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction 

" ---------------------------------------------------------------------------
"  for fzf
" ---------------------------------------------------------------------------
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


" ---------------------------------------------------------------------------
"  for ale
" ---------------------------------------------------------------------------
" let g:ale_fixers = {
" \   'ruby': ['rubocop'],
" \}
" 
" let g:ale_fix_on_save = 1
" ---------------------------------------------------------------------------
"  for ultisnips
" ---------------------------------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" ---------------------------------------------------------------------------
"  for vim-session
" ---------------------------------------------------------------------------
" let g:session_default_name = '.session'
" let g:session_extention = '.vim'
" let g:session_autosave = 'no'
" let g:session_autoload = 'no'
" ---------------------------------------------------------------------------
"  for vim-session
" ---------------------------------------------------------------------------
" let g:gsw_autoload_session = 'yes'
" augroup mysetting_git_switcher
"   autocmd!
"   autocmd VimLeavePre * call git_switcher#save_session()
" augroup END
" ---------------------------------------------------------------------------
"  for Vim-go
" ---------------------------------------------------------------------------
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0
let g:go_fmt_command = "goimports" " auto import with save
" let g:go_fmt_fail_silently = 1

" highlight settings (see :help go-settings)
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

" checking setting
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "60s"

" infomation setting
set updatetime=100
let g:go_auto_sameids = 1

augroup vim_go
  autocmd!
  autocmd FileType go nmap <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  " navigate setting
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" ---------------------------------------------------------------------------
"  for Rspec.vim
" ---------------------------------------------------------------------------
" RSpec.vim mappings
let g:rspec_command = "Dispatch bundle exec rspec --drb {spec}"
augroup rspec_vim
  autocmd!
  " autocmd FileType ruby map <Leader>t :call RunCurrentSpecFile()<CR>
  autocmd FileType ruby map <Leader>t :term bundle exec rspec %<CR>
  autocmd FileType ruby map <Leader>s :call RunNearestSpec()<CR>
  autocmd FileType ruby map <Leader>l :call RunLastSpec()<CR>
  autocmd FileType ruby map <Leader>a :call RunAllSpecs()<CR>
augroup END
" ---------------------------------------------------------------------------
"  for Defx
" ---------------------------------------------------------------------------
call defx#custom#option('_', {
		\ 'columns': 'indent:git:icons:filename',
		\ 'show_ignored_files': 1,
		\ })

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>     defx#do_action('open')
  nnoremap <silent><buffer><expr> c        defx#do_action('copy')
  nnoremap <silent><buffer><expr> m        defx#do_action('move')
  nnoremap <silent><buffer><expr> p        defx#do_action('paste')
  nnoremap <silent><buffer><expr> l        defx#do_action('open')
  nnoremap <silent><buffer><expr> <C-v>    defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P        defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o        defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K        defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N        defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M        defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C        defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S        defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d        defx#do_action('remove_trash')
  nnoremap <silent><buffer><expr> r        defx#do_action('rename')
  nnoremap <silent><buffer><expr> !        defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x        defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy       defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .        defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;        defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h        defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~        defx#do_action('cd')
  nnoremap <silent><buffer><expr> q        defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>  defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *        defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j        line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k        line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>    defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>    defx#do_action('print')
  nnoremap <silent><buffer><expr> cd       defx#do_action('change_vim_cwd')
endfunction

call defx#custom#column('git', 'raw_mode', 1)
" ---------------------------------------------------------------------------
" for vim-lsp
" ---------------------------------------------------------------------------
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_virtual_text_enabled = 0
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 1
let g:lsp_highlight_references_enabled = 1

" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" for Go
" if executable('gopls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'gopls',
"         \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
"         \ 'whitelist': ['go'],
"         \ })
"     autocmd BufWritePre *.go LspDocumentFormatSync
" endif

" for Ruby
" if executable('solargraph')
"     " gem install solargraph
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'solargraph',
"         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
"         \ 'initialization_options': {"diagnostics": "true"},
"         \ 'whitelist': ['ruby'],
"         \ })
" endif

"for vue
" if executable('vls')
"   augroup LspVls
"     au!
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'vue-language-server',
"         \ 'cmd': {server_info->['vls']},
"         \ 'whitelist': ['vue'],
"         \ 'initialization_options': {
"         \         'config': {
"         \             'html': {},
"         \              'vetur': {
"         \                  'validation': {}
"         \              }
"         \         }
"         \     }
"         \ })
" 
"     " omnifunc
"     au FileType vue setlocal omnifunc=lsp#complete
"     " map
"     au FileType vue nnoremap <buffer><silent> gd :<C-u>LspDefinition<CR>
"     au FileType vue nnoremap <buffer><silent> gD :<C-u>LspReferences<CR>
"     au FileType vue nnoremap <buffer><silent> gs :<C-u>LspDocumentSymbol<CR>
"     au FileType vue nnoremap <buffer><silent> gS :<C-u>LspWorkspaceSymbol<CR>
"     au FileType vue nnoremap <buffer><silent> gQ :<C-u>LspDocumentFormat<CR>
"     au FileType vue vnoremap <buffer><silent> gQ :LspDocumentRangeFormat<CR>
"     au FileType vue nnoremap <buffer><silent> K :<C-u>LspHover<CR>
"     au FileType vue nnoremap <buffer><silent> <F1> :<C-u>LspImplementation<CR>
"     au FileType vue nnoremap <buffer><silent> <F2> :<C-u>LspRename<CR>
"   augroup end
" endif

" ---------------------------------------------------------------------------
" for asyncomplete.vim
" ---------------------------------------------------------------------------
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup()   : "\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" endwiseと競合していたため、遅延読み込み
" augroup lazyload
"   autocmd!
"   autocmd BufWritePost $MYVIMRC  inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"
" augroup END

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'whitelist': ['*'],
\ 'blacklist': ['c', 'cpp', 'html'],
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))

" buffer
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

" vim script
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \ 'name': 'necovim',
    \ 'whitelist': ['vim'],
    \ 'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))

