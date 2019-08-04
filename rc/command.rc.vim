" ++ 一時ファイル {{{
function! s:make_tempfile(win, ...)
  let l:win = (a:win == 0 ? "e" : (a:win == 1 ? "vs" : "sp"))
  exe l:win ." " .tempname()
  if exists("a:1") && a:1 != ""
    exe "set ft=" .a:1
  endif
  autocmd MyAutoCmd BufLeave <buffer> write
endfunction

command! -nargs=? Tempe call s:make_tempfile(0, "<args>")
command! -nargs=? Temp call s:make_tempfile(1, "<args>")
command! -nargs=? Temps call s:make_tempfile(2, "<args>")
" ++ }}}

" ++ カレントディレクトリをエクスプローラーで開く {{{
function! s:open_current_explorer()
  if has('mac')
    exe "silent ! open %:h"
  else
    exe "silent ! start %:h"
  endif
endfunction
command! OpenCurrentExplorer call s:open_current_explorer()
" ++ }}}

" ++ ケース変換 {{{
function! s:separate_word(str)
  return split( substitute(a:str, "\\L", "_\\l\\0", "gI"), "_")
endfunction

function! s:to_camel_case(is_lower, before_str)
  let l:words = s:separate_word(a:before_str)
  let l:after_str = ""
  if a:is_lower
    let l:after_str = remove(l:words, 0)
  endif

  for l:word in l:words
    let l:after_str = l:after_str . substitute(l:word, "^.", "\\u\\0", "")
  endfor
  execute "normal viws" . l:after_str
endfunction
command! -nargs=? ToCamelCase call s:to_camel_case(1, <f-args>)
command! -nargs=? ToPascalCase call s:to_camel_case(0, <f-args>)

function! s:to_snake_case(before_str)
  let l:words = s:separate_word(a:before_str)
  let l:after_str = join(l:words, '_')
  execute "normal viws" . l:after_str
endfunction
command! -nargs=? ToSnakeCase call s:to_snake_case(<f-args>)
" ++ }}}

"++ ファイルやディレクトリのヤンク {{{

function! s:yank_file_name()
  call setreg('"', expand("%:t"))
  echo expand("%:t")
endfunction
command! YankFileName call s:yank_file_name()

function! s:yank_file_path()
  call setreg('"', expand("%:p"))
  echo expand("%:p")
endfunction
command! YankFilePath call s:yank_file_path()

function! s:yank_file_dir()
  call setreg('"', expand("%:p:h"))
  echo expand("%:p:h")
endfunction
command! YankFileDir call s:yank_file_dir()
"++ }}}

"++ カレントファイルの再読込（vim） {{{
try
  function! s:source_current_file()
    if &filetype == "vim"
      exe "source %"
    endif
  endfunction
  command! SourceCurrentFile call s:source_current_file()
catch
endtry
"++ }}}

"++ 隠しバッファの削除 {{{
function! s:delete_hidden_buffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! DeleteHiddenBuffers call s:delete_hidden_buffers()
"++ }}}
