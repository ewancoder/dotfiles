set ic nu tabstop=4 expandtab shiftwidth=4 softtabstop=4 history=10000 wildmode=full wildmenu

nnoremap <space> <nop>
let mapleader=" "

"nnoremap h <nop>
"nnoremap j <nop>
"nnoremap k <nop>
"nnoremap l <nop>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>a :wa<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>o :only<CR>
nnoremap <Leader>c :close<CR>
nnoremap gm :vsc Edit.NextMethod<CR>
nnoremap gM :vsc Edit.PreviousMethod<CR>

map gi :vsc Edit.GoToImplementation<CR>
map <Leader>f :vsc Edit.GoToPreviousIssueinFile<CR>
map <Leader>d :vsc Edit.GoToNextIssueinFile<CR>
"map <Leader>h :vsc Debug.StepOver<CR>
map <Leader><Esc> :noh<CR>
map <Leader>o :vsc File.CloseOtherTabs<CR>
map <Leader>l :vsc Window.MoveToNextTabGroup<CR>
map <Leader>h :vsc Window.MoveToPreviousTabGroup<CR>
nnoremap J :vsc Window.PreviousTab<CR>
nnoremap K :vsc Window.NextTab<CR>
nnoremap H :vsc View.NavigateBackward<CR>
nnoremap L :vsc View.NavigateForward<CR>

vmap <Leader>y "*y
vmap <Leader>p "*p

set hls

syntax on
