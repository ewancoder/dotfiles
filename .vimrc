"---------- Vundle ----------
"Vim&Vi
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'lilydjwg/colorizer'
Bundle 'tpope/vim-fugitive'
"Snipmate depencencies
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
"Snipmate itself
Bundle 'garbas/vim-snipmate'
"SnipmateS itself :)
Bundle 'honza/vim-snippets'
Bundle 'Raimondi/delimitMate'
"Python autocompletion (jedi)
Bundle 'davidhalter/jedi-vim'
"Instead of powerline - airline (viml instead of python+corrupted fonts
Bundle "bling/vim-airline"
"Command-T (not for Dropbox :))
Bundle "wincent/Command-T"
"I NEED THIS
""Bundle "klen/python-mode"

filetype plugin indent on

"---------- General ----------
set history=5000
"Autoread when file is changed from the outside
set autoread
"Setup backup&swap dirs
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
"Set hidden buffer
set hidden
"STRANGE option (but good perfomance)
""set lazyredraw (dont redraw while executing macros)
"Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
"Encoding
set encoding=utf8
"Backspace acts like normal (Do I need it?)
"Set backspace=eol,start,indent

"---------- Colors/interface ----------
colorscheme desert
syntax on
"Set scrolloff to 5 lines
set so=5
"Turn on wildmenu (highlight commandline Tab)
set wildmenu
set wildignore=*.o,*~
"Show matching brackets / blink time
set showmatch
set mat=2
"Remove all gui menus (only hardcore)
set guioptions=ac
"Little bit margin to the left
set foldcolumn=1
"TABS configuration
set expandtab		"Turn Tab to Spaces
set smarttab		"Backspace delete all Spaces
set shiftwidth=4	"1 Tab = 4 Spaces
set tabstop=4		"Real Tab length = 4 Spaces
set autoindent
set smartindent
"TABS for html
autocmd FileType html :setlocal sw=2 ts=2 sts=2
set number
"Highlight OVER 80
""highlight OverLength ctermbg=red ctermfg=white guibg=#592929
""match OverLength /\%81v.\+/
"Autocompletion pink color remove
:highlight Pmenu guibg=black guifg=yellow
:highlight PmenuSel guibg=green

"---------- Mapping ----------
"Timeout ,g vs ,gv (default=1000)
set timeoutlen=500
"Leader key
let mapleader=","
let g:mapleader=","
"Easy edit .vimrc
nmap <silent> ,ev :e $MYVIMRC<cr>
nmap <silent> ,sv :so $MYVIMRC<cr>
"Fast saving / sudo saving
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
cmap w!! w !sudo tee > /dev/null %
"Easy windows switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
"Easy search (I suppose, I don't need it :))
map <space> /
map <c-space> ?
"Close current buffer
map <leader>bd :bd<cr>
"Close all the buffers
map <leader>ba :1,1000 bd!<cr>
"Managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tq :tabclose<cr>
"Just for wrapping text browsing
map j gj
map k gk
"Don't jump on *
nnoremap * *N
"Turn off lights
nnoremap <F8> :nohlsearch<CR>
"Whitespaces signs
if has('multi_byte')
    if version >= 700
        set listchars=tab:▸\ ,eol:¬
    else
        set listchars=tab:»\ ,trail:·,eol:¶,extends:>,precedes:<,nbsp:_
    endif
endif
nmap <leader>l :set list!<CR>
"Moving through tabs
map <leader>n <esc>:tabprevious<CR>
map <leader>m <esc>:tabnext<CR>
"Sort alphabetically :)
vnoremap <Leader>s :sort<CR>
"Moving code blocks
vnoremap < <gv
vnoremap > >gv
"Run python
verbose nmap <F5>!python %

"---------- Plugins ----------

"Colorizer don't work until I reload it manually, so for now I just disable it
"for purpose of just enabling it (and not disable before enabling)
let g:colorizer_startup = 0

"DelimitMate
let delimitMate_expand_space=1
let delimitMate_expand_cr=1

"Snipmate Tab remap
"map <C-j> <Plug>snipMateNextOrTrigger

"AutoCompletion colors
""highlight Pmenu guibg=black

"For Airline for working with 1 window
""set laststatus=2

"YCM
""let g:ycm_autoclose_preview_window_after_completion=1
""nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

"AirLine
let g:airline_theme = 'dark'
let g:airline_enable_fugitive=1 "Fugitive
""let g:airline_enable_syntastic=1 "Syntastic
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_linecolumn_prefix = '¶ '
let g:airline_fugitive_prefix = '⎇ '
let g:airline_paste_symbol = 'p'

""let g:airline_section_c = '%t ' "Separate sections change

""let g:airline#extensions#tagbar#enabled = 1 "Tagbar support
""let g:airline#extensions#syntastic#enabled=1


map <leader>f :CommandT<CR>
map <leader>b :CommandTBuffer<CR>


"Python-mode