set encoding=utf-8
scriptencoding utf-8
"--------------------------------------------------
" base setting.
" --------------------------------------------------
syntax on
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set helplang=ja,en
set shortmess+=l
set clipboard=unnamed,autoselect
set backspace=eol,indent,start
set incsearch
set hlsearch
set fileformats=unix,dos,mac
" --------------------------------------------------
" Key Binds.
" --------------------------------------------------
" vimrc参照
nnoremap <space>. :<C-u>e ~/.vimrc <CR>
nnoremap <space>s. :<C-u>source ~/.vimrc <CR>

" help参照
nnoremap <C-h> :<C-u>help<space>
nnoremap <C-h><C-h> :<C-u>help<space> <C-r><C-w><Enter>

noremap : ;
noremap ; :

nnoremap <space>h 0
nnoremap <space>l $

inoremap <C-j> <esc>


" --------------------------------------------------
" neobundle setting.
" --------------------------------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

NeoBundle 'vim-jp/vimdoc-ja'		" ヘルプ日本語化
NeoBundle 'thinca/vim-quickrun'	" コード実行プラグイン
NeoBundle 'junegunn/seoul256.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'vim-jp/autofmt'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'basyura/unite-rails'
NeoBundle 'ruby-matchit'
NeoBundle 'surround.vim'
" ドキュメント参照
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'
" メソッド定義元へのジャンプ
 NeoBundle 'szw/vim-tags'
" 自動で閉じる
NeoBundle 'tpope/vim-endwise'
" コード補完
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'marcus/rsense'
NeoBundle 'supermomonga/neocomplete-rsense.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \   }
      \ }

call neobundle#end()

" --------------------------
"vim-tags 
" --------------------------
let g:vim_tags_project_tags_command = "/usr/local/bin/ctags -R {OPTIONS} {DIRECTORY} 2>/dev/null"
let g:vim_tags_gems_tags_command = "/usr/local/bin/ctags -R {OPTIONS} `bundle show --paths` 2>/dev/null"

" --------------------------
" syntastic
" --------------------------
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
" :wq で閉じるとき、チェックを走らせない
let g:syntastic_check_on_wq = 0

" --------------------------
" previm
" --------------------------
let g:previm_open_cmd = 'open -a Safari'

" --------------------------
" vim-markdown 
" --------------------------
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" --------------------------
" RSence
" --------------------------
let g:rsenseHome = expand("~/.vim/bundle/rsense")
let g:rsenseUseOmniFunc = 1

" --------------------------------
" neocomplete.vim
" --------------------------------
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

" --------------------------
" neocomplete-rsence
" --------------------------
let g:neocomplete#sources#rsense#home_directory = expand("~/.vim/bundle/rsense")

" --------------------------
" unite
" --------------------------
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> <space>ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> <space>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> <space>ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> <space>um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> <space>uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> <space>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q 


" --------------------------
" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

if !has('vim_starting')
  " .vimrcを読み込み直した時のための設定
  call neobundle#call_hook('on_source')
endif
