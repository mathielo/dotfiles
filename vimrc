set nocompatible
set noswapfile

" Remap ; to : to skip Shift for command mode
nnoremap ; :

" Indentation
set expandtab
set shiftwidth=2
set shiftround
set softtabstop=2
set autoindent
set smartcase

filetype plugin indent on

" Splits
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Sudo save
cmap w!! w !sudo tee % >/dev/null
