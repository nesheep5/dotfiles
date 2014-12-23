" --------------------------------------------------
" base setting.
" --------------------------------------------------
syntax on
set number
set helplang=ja,en
set shortmess+=l
set clipboard=unnamed,autoselect

" --------------------------------------------------
" Key Binds.
" --------------------------------------------------
nnoremap <space> :e ~/.vimrc <CR>
nnoremap <space>s. :source ~/.vimrc <CR>

nnoremap <space>h ^	 
nnoremap <space>l $	 
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
 NeoBundle 'tpope/vim-fugitive'

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

