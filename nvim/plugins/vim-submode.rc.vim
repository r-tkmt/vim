"submodeを抜け出すときのコマンドを有効に
let g:submode_keep_leaving_key=1
let g:submode_timeout=0

" タブ操作サブモード
call submode#enter_with('tab_close', 'n', '', '<Leader>tq', ':<C-u>tabc<CR>')
call submode#map('tab_close', 'n', '', 'q', ':<C-u>tabc<CR>')
call submode#enter_with('tab_move', 'n', '', '<Leader>th', 'gT')
call submode#enter_with('tab_move', 'n', '', '<Leader>tl', 'gt')
call submode#enter_with('tab_move', 'n', '', '<Leader>tH', ':<C-u>tabr<CR>')
call submode#enter_with('tab_move', 'n', '', '<Leader>tL', ':<C-u>tabl<CR>')
call submode#map('tab_move', 'n', '', 'h', 'gT')
call submode#map('tab_move', 'n', '', 'H', ':<C-u>tabr<CR>')
call submode#map('tab_move', 'n', '', 'l', 'gt')
call submode#map('tab_move', 'n', '', 'L', ':<C-u>tabl<CR>')

" ウィンドウ操作サブモード
call submode#enter_with('window', 'n', '', '<Leader>wh', '<C-w>h')
call submode#enter_with('window', 'n', '', '<Leader>wl', '<C-w>l')
call submode#map('window', 'n', '', 'h', '<C-w>h')
call submode#map('window', 'n', '', 'l', '<C-w>l')
call submode#enter_with('window', 'n', '', '<Leader>wd', '10<C-w>-')
call submode#enter_with('window', 'n', '', '<Leader>wu', '10<C-w>+')
call submode#enter_with('window', 'n', '', '<Leader>wU', '<C-w>_')
call submode#enter_with('window', 'n', '', '<Leader>w.', '12<C-w>>')
call submode#enter_with('window', 'n', '', '<Leader>w,', '12<C-w><')
call submode#enter_with('window', 'n', '', '<Leader>w=,', '<C-w>=')
call submode#map('window', 'n', '', 'd', '10<C-w>-')
call submode#map('window', 'n', '', 'u', '10<C-w>+')
call submode#map('window', 'n', '', 'm', '<C-w><Bar>')
call submode#map('window', 'n', '', '.', '12<C-w>>')
call submode#map('window', 'n', '', ',', '12<C-w><')
call submode#map('window', 'n', '', '=', '<C-w>=')
