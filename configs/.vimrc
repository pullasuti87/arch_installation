""" VIM CONFIGURATION (no externel plugins)
" Last Updated: 18/10/2024 (arch)

set nocompatible " disable compatibility with vi

colorscheme sorbet " retrobox desert, peachpuff, slatea, sorbet
set background=dark
set termguicolors " 24-bit true color support
syntax on " syntax highlight

set title " dynamic title
set titlestring=%F " full path of the file

set number " line numbers
set relativenumber " relative line numbers
set cursorline " highlight current line
set laststatus=2 " displays statusline (HIDDEN)
set noshowmode " hide mode from the command line

set textwidth=80 " maximum width for line wrapping
" set colorcolumn=80 " highlight a vertical line at column

set wildmenu " better command-line completion
set wildmode=longest,list,full " file and command-line tab completion
set completeopt=menuone,longest,preview " auto completion as you type

set tabstop=4 " number of spaces in a tab
set softtabstop=4 " number of spaces when pressing tab
set expandtab " replaces typed tabs the number of spaces
set shiftwidth=4 " number of spaces for each level of indentation
set scrolloff=8 " scrolling show upcoming lines

set autoindent " ineindents a new line to match the previous line's indentation
set smartindent " automatically aliging code within blocks

set nohlsearch " disable highlighting of search matches
set incsearch " incremental search highlighting

set ignorecase " peforms a case-insensitive search
set smartcase " peforms case-sensitive search based on characters

set noswapfile " no swap files
set nobackup " no backups
" let &undodir = expand("$HOME") . "/.vim/undodir" " customte custom file
" set undofile " store undo history

set mouse=a " mouse support

set splitbelow " split new buffer below
set termwinsize=10x0 " set terminal window height

" open netrw
nnoremap <Space>e :Explore<CR>

" open terminal
nnoremap <Space>t :term<CR>
" exit terminal mode back to normal mode
tnoremap <Space>b <C-\><C-n>

" sets numbers and relativenumbers ON
nnoremap cp+ :set number relativenumber<CR>
" sets numbers and  relativenumbers OFF
nnoremap cp- :set nonumber norelativenumber<CR>

" default clipboard
" set clipboard+=unnamedplus

" copy clipboard
vnoremap <C-c> y:call system("wl-copy", @")<CR>:echo "Copied " . len(@") . " characters"<CR>" paste clipboard
" paste clipboard
nnoremap <C-v> :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<CR>:let @a=@"<CR>p:echo "Pasted " . len(@a) . " characters"<CR>

" custom auto-pairing
inoremap (<CR> ()<Left>
inoremap [<CR> []<Left>
inoremap {<CR> {}<Left>
inoremap "<CR> ""<Left>
inoremap '<CR> ''<Left>
inoremap <<CR> <><Left>

" indent file
nnoremap <Space>f gg=G

" navigate completion menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" navigate between windows
nnoremap <Space>w <C-w><C-w>

" modes
let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'VISUAL-Line ',
       \ "\<C-V>" : 'VISUAL-Block ',
       \ 'i'  : 'INSERT ',
       \ 'c'  : 'COMMAND ',
       \ 't'  : 'TERMINAL ',
       \}

" custom statusline
if has('statusline')
  " set statusline+=%{SyntaxItem()} " syntax highlight group under cursor
  set statusline+=\         " empty space
  set statusline+=\ %{toupper(g:currentmode[mode()])} " current mode
  set statusline+=\|\       " pipe character
  set statusline+=%m        " modified flag
  set statusline+=%=%F      " file name
  set statusline+=%=        " right-align items
  set statusline+=%l:       " current line number
  set statusline+=%c\       " column number
  set statusline+=\         " empty space
endif

" shows what highlight group is under cursor
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" remove trailing whitespaces before saving
au BufWritePre * :%s/\s\+$//e

" activate cursoline
au BufEnter,WinEnter * setlocal cursorline
" disable cursorline when leaving buffer
au BufLeave,WinLeave * setlocal nocursorline

" autocommand to check if files are netrw
au Filetype netrw call CheckIfNetrw()
" makes the function call when entring buffer or window
au BufEnter,WinEnter * call CheckIfNetrw()
" removes statusline if user enters netrw
function! CheckIfNetrw()
  if &filetype ==# 'netrw'
    setlocal laststatus=0
  else
    setlocal laststatus=2
  endif
endfunction

" custom command
command! -nargs=+ G call GrepSearch(<q-args>)

" takes parameter, makes a vimgrep search
function! GrepSearch(args)
    " escape special characters in search pattern
    let l:escaped_args = escape(a:args, '\')
    let l:command = 'vimgrep /\c' . l:escaped_args . '/j **/*'

    try
        execute l:command
        copen
    catch
        echoerr 'error executing vimgrep'
    endtry
endfunction


""" GVim configs
" check if running in GVim or terminal
" if has("gui_running")
"     "set guioptions-=m " hides menu bar
"     set guioptions-=T " hides toolbar
"     set guioptions-=r " hides scrollbar
"
"     set columns=90 " set width
"     set lines=44 " set height
" endif

