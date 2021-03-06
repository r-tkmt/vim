let g:syntastic_error_symbol = "-\u0078"
let g:syntastic_warning_symbol = "-\u0021"
let g:syntastic_style_error_symbol = "S\u0078"
let g:syntastic_style_warning_symbol = "S\u0021"

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_cursor_column = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_mode_map = {
\ 'mode': 'active',
\ 'active_filetypes': [
\   'ruby', 'javascript', 'html', 'vim', 'sql', 'yaml'
\ ],
\ 'passive_filetypes': [
\   'eruby'
\ ]}
