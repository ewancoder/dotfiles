xnoremap "*y y:call system("wl-copy", @")<cr>
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
