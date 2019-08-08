set number
set noswapfile

set background=dark
colorscheme solarized8


inoremap <silent> jj <ESC>
nnoremap <F5> :vsplit $MYVIMRC<CR>
nnoremap <F6> :source $MYVIMRC<CR> :echo 'reload init.vim'<CR> 



call plug#begin('~/.vim/plugged')
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'fatih/vim-go'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
