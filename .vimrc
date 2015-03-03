" --------------------------------------------------
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
" --------------------------------------------------
" Key Binds.
" --------------------------------------------------
" vimrc参照
nnoremap <space>. :e ~/.vimrc <CR>
nnoremap <space>s. :source ~/.vimrc <CR>

" help参照
nnoremap <C-h> :<C-u>help<space>
nnoremap <C-h><C-h> :<C-u>help<space> <C-r><C-w><Enter>

noremap : ;
noremap ; :

nnoremap <space>h 0
nnoremap <space>l $

inoremap <C-j> <esc>

" RSence
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'

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

"=== unite.vim ===
NeoBundle 'Shougo/unite.vim'
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
   NeoBundle 'Shougo/neomru.vim'
   NeoBundle 'tpope/vim-fugitive'
   NeoBundle 'vim-jp/autofmt'

"=== vim-markdown ===
 NeoBundle 'tpope/vim-markdown'
 autocmd BufNewFile,BufReadPost *.md set filetype=markdown

 NeoBundle 'kannokanno/previm'
 let g:previm_open_cmd = 'open -a Safari'

"=== syntastic ==="
NeoBundle 'scrooloose/syntastic'
let g:syntastic_ruby_checkers = ['rubocop']


"=== vim-ruby ===
 NeoBundle 'vim-ruby/vim-ruby'
"=== vim-scala ===
 NeoBundle 'derekwyatt/vim-scala'

 "=== neocomplcache ===
NeoBundle 'Shougo/neocomplcache'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

 call neobundle#end()

 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck

if !has('vim_starting')
  " .vimrcを読み込み直した時のための設定
  call neobundle#call_hook('on_source')
endif


