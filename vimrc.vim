scriptencoding utf-8
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 18-Nov-2017.
" Maintainer:  Ryo Tsukamoto <r12tkmt@gmail.com>
"
" + kaoriya default settings {{{

" ++ plugins下のディレクトリをruntimepathへ追加 {{{
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor
unlet! s:path
" ++ }}}
" ++ 日本語対応のための設定: {{{
"
" ファイルを読込むにトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
"source $VIM/plugins/kaoriya/encode_japan.vim

" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
set encoding=utf-8
set fileencodings=utf-8
"set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set encoding=utf-8
  set ambiwidth=double
  if exists('$LANG') && $LANG ==# 'ja_JP.UTF-8'
    set langmenu=ja_ja.utf-8.macvim
  endif
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "インサートモード、検索モード時のIMEの初期値 0:off 1:on
  " set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif
" ++ }}}
"  ++ その他設定{{{
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif
if has('nvim')
  set clipboard+=unnamed
endif

" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  if !exists("g:restarted")
    let $PATH = $VIM . ';' . $PATH
  endif
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif
" ++ }}}
" ++ KaoriYaでバンドルしているプラグインのための設定 {{{

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if has('win32') && kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
endif

" vimproc: 同梱のvimprocを無効化する
" if kaoriya#switch#enabled('disable-vimproc')
"   let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
" endif
" ++ }}}
" + }}}
" + vim standard settings {{{
augroup MyAutoCmd
  autocmd!
augroup END
augroup MyAutoLazyCmd
  autocmd!
augroup END
syntax enable
if has('nvim')
  if has('patch-7.4.1778')
    set guicolors
  endif
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  " 256色
  set t_Co=256
  set termguicolors
  " 背景色
  set background=dark
endif
" ++ 検索の挙動に関する設定:{{{
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
"インクリメンタルサーチを行う
set incsearch
"検索結果をハイライト
set hlsearch
autocmd MyAutoCmd QuickFixCmdPost *grep* cwindow
" ++ }}}
" ++ 編集に関する設定: {{{
"
" タブの画面上での幅
set tabstop=2
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

set virtualedit+=block
" ++ }}}
" ++ GUI固有ではない画面表示の設定: {{{
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set nowrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
"閉括弧が入力された時、対応する括弧を強調する
set showmatch
" 文脈によって解釈が異なる全角文字の幅を、2に固定する
set ambiwidth=double
" vimが自動で生成する（読み込み時など）tab幅をスペース2つ文にする
set shiftwidth=2
" 改行時などに、自動でインデントを設定してくれる
set smartindent
"vim設定をグループ化して閉じる
autocmd MyAutoCmd FileType vim setlocal foldmethod=marker
" ++ }}}
" ++ ファイル操作に関する設定: {{{
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup
" swapファイルを作成しない
set noswapfile
" undoファイルを作成しない
set noundofile
" ++ }}}
" ++ その他：{{{
" "0"で始まる数値を、8進数として扱わないようにする
set nrformats-=octal
" ファイルの保存をしていなくても、べつのファイルを開けるようにする
set hidden

set history=50
"新しい行を作った時に高度な自動インデントを行う
set smarttab
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 行を強調表示
set cursorline
" 列を強調表示
" set cursorcolumn
" power_line に必須
set t_Co=256
" 挿入モードのIMEのデフォルト値
set iminsert=0
" 検索時のIMEのデフォルト値(-1はiminsertの値を参照するという意味)
set imsearch=-1
" Windows でもパスの区切り文字を / にする
set shellslash
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full

" 画面分割時の位置
set splitbelow
set splitright

"" texのconcealを無効化（#^ω^）
let g:tex_conceal=''
set conceallevel=0

" 一時ファイルを作成して開く、Tempfileコマンドを定義
command! TempfileRuby :vs `=tempname()`|set ft=ruby
" ++ }}}
" + }}}
" + dein {{{
if has('nvim')
  let s:dein_cache_path = expand('~/.vim/cache/nvim/dein')
else
  let s:dein_cache_path = expand('~/.vim/cache/vim/dein')
endif

let s:dein_dir = s:dein_cache_path .'/repos/github.com/Shougo/dein.vim'
if &runtimepath !~ '/dein.vim'
  if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim ' . s:dein_dir
  endif
  execute 'set runtimepath+=' . s:dein_dir
endif

if dein#load_state(s:dein_cache_path)
  call dein#begin(s:dein_cache_path)

  call dein#load_toml($XDG_CONFIG_HOME . '/dein.toml', {'lazy' : 0})
  call dein#load_toml($XDG_CONFIG_HOME . '/deinlazy.toml', {'lazy' : 1})
  call dein#end()
  call dein#save_state()
endif

"if dein#check_install(['vimproc.vim'])
"  call dein#install(['vimproc.vim'])
"endif
if !has('vim_starting') && dein#check_install()
  call dein#install()
endif
" deinの読み込み後に行う
" filetype on
colorscheme rytkmt
filetype plugin indent on
set noimdisable
" }}}
" コマンド{{{
" ++ タブ操作 {{{
" タブを閉じる
nnoremap [tab]q :<C-u>tabc<CR>
" 開いているタブ以外を閉じる
nnoremap [tab]o :<C-u>tabo<CR>
" 新規タブ
nnoremap [tab]n :<C-u>tabnew<CR>
" タブの詳細一覧
nnoremap [tab]s :<C-u>tabs<CR>
" タブ移動（左）
nnoremap [tab]h gT<CR>
" タブ移動（左端）
nnoremap [tab]H :<C-u>tabr<CR>
" タブ移動（右）
nnoremap [tab]l gt<CR>
" タブ移動（右端）
nnoremap [tab]L :<C-u>tabl<CR>
" タブ移動（番号）
nnoremap [tab]1 :<C-u>tabn 1<CR>
nnoremap [tab]2 :<C-u>tabn 2<CR>
nnoremap [tab]3 :<C-u>tabn 3<CR>
nnoremap [tab]4 :<C-u>tabn 4<CR>
nnoremap [tab]5 :<C-u>tabn 5<CR>
nnoremap [tab]6 :<C-u>tabn 6<CR>
nnoremap [tab]7 :<C-u>tabn 7<CR>
nnoremap [tab]8 :<C-u>tabn 8<CR>
nnoremap [tab]9 :<C-u>tabn 9<CR>
nnoremap [tab]10 :<C-u>tabn 10<CR>
nnoremap [tab]m :<C-u>call <SID>move_buf_to_new_tab()<CR>

" 作業ウィンドウを別タブで開く
function! s:move_buf_to_new_tab()
  let move_buf_to_new_tab_path = expand("%:p")
  try
    q
  catch
    return
  endtry
  execute "tabe " . move_buf_to_new_tab_path
endfunction
" ++ }}}
" ++ ウィンドウ操作 {{{

" ウィンドウ遷移
nnoremap [window]h <C-w>h
nnoremap [window]j <C-w>j
nnoremap [window]k <C-w>k
nnoremap [window]l <C-w>l
" ウィンドウ移動
nnoremap [window]H <C-w>H
nnoremap [window]J <C-w>J
nnoremap [window]K <C-w>K
nnoremap [window]L <C-w>L
" 高さ変更
nnoremap [window]d 10<C-w>-
nnoremap [window]u 10<C-w>+
" 高さ最大
nnoremap [window]U <C-w>_
" 幅変更
nnoremap [window]. 12<C-w>>
nnoremap [window], 12<C-w><
" 幅最大化
nnoremap [window]m <C-w><Bar>
" 幅揃える
nnoremap [window]= <C-w>=

"ヤンク文字で検索
cmap <S-Space> <C-r>"
cmap <C-Space> <C-r>*
"挿入モード終了
imap <C-Space> <ESC>
vmap <nowait> <C-Space> <ESC>
nmap <C-Space><C-Space> :<C-u>noh<CR>
" ++ }}}
" ++ その他 {{{
"ヤンクした値がdやxで消えないように（復活させる）
nnoremap PP "0p
vnoremap PP "0p
nnoremap ZZ <Nop>
nnoremap <C-z> <Nop>

vnoremap d "_d
nnoremap d "_d
vnoremap D "_D
nnoremap D "_D
vnoremap x "_x
nnoremap x "_x
vnoremap s "_s
nnoremap s "_s
nnoremap t d
vnoremap t x
nnoremap tt dd
nnoremap tL d$
nnoremap T D
nnoremap <C-c> viws
nnoremap y%f :<C-u>redi! @"> \| echo expand("%:t") \| redi END<CR>
nnoremap y%p :<C-u>redi! @"> \| echo expand("%:p") \| redi END<CR>
nnoremap y%d :<C-u>redi! @"> \| echo expand("%:p:h") \| redi END<CR>
nnoremap <ESC><ESC> :<C-u>noh<CR>
cmap <C-j> <LEFT>
cmap <C-k> <RIGHT>

" 逆に普通の行単位で移動したい時のために逆の map も設定しておく
nnoremap gj j
nnoremap gk k

" 行を移動
nnoremap <C-Up> "zdd<Up>"zP
nnoremap <C-Down> "zdd"zp
" 複数行を移動
vnoremap <C-Up> "zx<Up>"zP`[V`]
vnoremap <C-Down> "zx"zp`[V`]

" カーソル移動
noremap <S-h>   ^
noremap <S-j>  4gj
noremap <C-j>   }
noremap <S-k>  4gk
noremap <C-k>   {
noremap <S-l>   $

" 画面移動
noremap zl zL
noremap zh zH
noremap zj 4<C-e>
noremap zk 4<C-y>

" 削除
imap <C-h> <BS>
inoremap <C-d> <C-o>"_dd
inoremap <C-b> <C-o>"_db<C-o>x
inoremap <C-e> <C-o>"_de

inoremap <C-p> <C-o>p

" カーソル位置の単語を置換
nnoremap <expr> <C-s> ':%s/\<' . expand('<cword>') . '\>/'
vnoremap <expr> <C-s> ':s/\<' . expand('<cword>') . '\>/'

autocmd MyAutoLazyCmd VimEnter * nnoremap <nowait> <expr> gc '`[' . getregtype()[0] . '`]'

" ruby if endの%移動
source $VIMRUNTIME/macros/matchit.vim
augroup matchit
  au!
  au FileType ruby let b:match_words = '\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
augroup END
nmap m %
vmap m %
" マーク
nnoremap M m
nnoremap MM :<C-u>marks<CR>
" 前回変更点をVモードで選択
nnoremap <expr> <C-h> ':h ' . expand('<cword>')

"メタ文字扱いのオプションをvery magicを初期値に
nnoremap / /\v
nnoremap ? ?\v
" キーマップ用
let mapleader = "\<Space>"
nmap , [map]
vmap , [map]
nmap [map] <Nop>

"=================================
"
"  q  w  e  r  t  y  u  i  o  p
"
"   A  S  d  f  g  h  j  k  l ;
"
"    z  X  C  v  b  n  m  ,  .
"
"=================================
map <Space> <Nop>
"単語ハイライト
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>

" コピペ
vmap <Leader>c "*y
nmap <Leader>v "*p
vmap <Leader>v "*p

nmap <Leader>z [other]
nmap <Leader>t [tab]
nmap <Leader>w [window]
nmap <Leader>1 [ref]
nmap <Leader>q [quick]
nmap [quick] <Nop>
nmap <Leader>e [edit]
nmap [unite] <Nop>

nmap <Leader>u [unite]

nmap [filer] <Nop>
nmap <Leader>f [filer]

nmap [search] <Nop>
nmap <Leader>s [search]

nmap  [rails] <Nop>
nmap <Leader>r [rails]

nmap [ctag] <Nop>
vmap [ctag] <Nop>
nmap <Leader>g [ctag]
vmap <Leader>g [ctag]
nmap <Leader>p [ctrlp]
nmap [ctrlp] <Nop>

nnoremap [ft] <Nop>
nmap <Leader>; [ft]

nmap [denite] <Nop>
nmap <Leader>d [denite]

"=================================
" _
" 1  2  3  4  5  6  7  8  9  0
"  _  _  _  _  _     _        _
"  Q  W  E  R  T  y  U  i  o  P
"      _  _  _  _             _
"   a  S  D  F  G  h  j  k  l ;
"    _     _  _
"    Z  x  C  V  b  n  m  ,  .
"
"=================================

nnoremap [other]h :so $VIMRUNTIME/syntax/hitest.vim
nnoremap [other]s :sp<CR>:VimShellBufferDir<CR>
nnoremap [other]r ::VimShellInteractive irb<CR>
nnoremap [other]v :<C-u>tabedit $XDG_CONFIG_HOME/vimrc.vim<CR>
nnoremap [other]l :<C-u>so ~/.vimrc<CR>:<C-u>so ~/.gvimrc<CR>
nnoremap [edit]s :e ++enc=shift_jis<CR>
nnoremap [edit]u :e ++enc=utf-8<CR>
nnoremap [edit]e :e ++enc=euc-jp<CR>

if has('win32')
  let $MEMO = $HOME . '/workspace/sql.sql'
  let $TESTRB = $HOME . '/workspace/test.rb'
  nnoremap [other]q :<C-u>tabedit $MEMO<CR>
  nnoremap [other]t :<C-u>tabedit $TESTRB<CR>
endif
"if has('syntax')
"  autocmd MyAutoCmd BufWinEnter * let w:m1 = matchadd("ZenkakuSpace", '　')
"  autocmd MyAutoCmd WinEnter * let w:m1 = matchadd("ZenkakuSpace", '　')
"endif
" ++ }}}
" ++ ファイルタイプ別{{{
" +++ help{{{
autocmd MyAutoCmd FileType help nnoremap <buffer> q :q<CR>
" +++ }}}
" +++ vimshell{{{
autocmd MyAutoCmd FileType vimshell nmap <buffer> o Ga
" +++ }}}
" +++ ruby{{{
function! s:to_camel_case(before_str)
  let l:after_str = ""
  for l:before_char in split(a:before_str, '_')
    let l:after_str = l:after_str . substitute(l:before_char, "^.", "\\u\\0", "")
  endfor
  execute "normal viws" . l:after_str
endfunction
command! -nargs=? ToCamelCase call s:to_camel_case(<f-args>)
autocmd MyAutoCmd FileType ruby nnoremap <expr> [ft]c ':ToCamelCase ' . expand('<cword>') .'<CR>'

function! s:to_snake_case(before_str)
  let l:before_str = substitute(a:before_str, "^.", "\\l\\0", "")
  let l:after_str = ""
  for i in range(0,strlen(l:before_str)-1)
    if l:before_str[i] ==# toupper(l:before_str[i])
      let l:after_str = l:after_str . substitute(l:before_str[i], "[A-Z]", "_\\l\\0", "")
    else
      let l:after_str = l:after_str . l:before_str[i]
    endif
  endfor
  execute "normal viws" . l:after_str
endfunction
command! -nargs=? ToSnakeCase call s:to_snake_case(<f-args>)
autocmd MyAutoCmd FileType ruby nnoremap <expr> [ft]s ':ToSnakeCase ' . expand('<cword>') .'<CR>'
" +++ }}}
" ++ }}}
" +}}}
" + ctags系 {{{
  function! s:CheckProject()
    if(!dein#tap('airblade/vim-rooter') || !dein#tap('Shougo/vimproc.vim'))
      return
    endif

    let l:open_project = FindRootDirectory()

    "Rakefileの存在でrailsプロジェクトか判断
    if filereadable(l:open_project .'/Rakefile')
      if !exists('g:gem_paths')
        call s:SetGemPaths()
      endif

      if !exists('g:gem_paths') && len(g:gem_paths) > 0 && !exists('g:gem_tags')
        call s:SetGemTags()
      endif

      if !exists('w:current_project') || w:current_project != l:open_project
        let w:current_project = l:open_project
        exe ':cd ' . w:current_project
        call s:ChangeProject()
      endif
    else
      if exists('w:project_tag')
        unlet w:project_tag
      endif
    endif
  endfunction

  function! s:SetGemPaths()
    let l:gem_paths = []
    if has('win32')
      let l:gem_paths = split(system('gem environment gempath'), ';')
    else
      " 配列で返るため明示的に0指定(要素は1つのため問題なし)
      let l:gem_paths = split(split(system('! gem environment gempath'), '\r')[0], ':')
    endif

    let g:gem_paths = []
    for gem_path in l:gem_paths
      let l:gem_root = substitute(gem_path, '\n', '', 'g') . '/gems'
      if isdirectory(l:gem_root)
        call add(g:gem_paths, l:gem_root)
      endif
    endfor
  endfunction

  function! s:SetGemTags()
    let g:gem_tags = []
    for gem_path in g:gem_paths
      if filereadable(gem_path . '/tags')
        call add(g:gem_tags, gem_path . '/tags')
      endif
    endfor
  endfunction

  function! s:ChangeProject()
    if !exists('w:current_project')
      return
    endif
    if exists('w:project_tag')
      unlet w:project_tag
    endif

    if filereadable(w:current_project . '/tags')
      let w:project_tag = w:current_project . '/tags'
    endif

    let l:set_tags = []
    if exists('w:project_tag')
      call add(l:set_tags, w:project_tag)
    endif

    if exists('g:gem_tags') && len(g:gem_tags) > 0
      for gem_tag in g:gem_tags
        call add(l:set_tags, gem_tag)
      endfor
    endif

    if len(l:set_tags) > 0
      let &l:tags=join(l:set_tags, ',')
    endif
  endfunction

  function! s:GenerateProjectTag()
    let l:project = FindRootDirectory()
    if filereadable(l:project .'/Rakefile')
      " tagファイルを削除
      try
        if filereadable(l:project . '/tags')
          if has('win32')
            call system("DEL " . l:project . '/tags')
          else
            call system("rm " . l:project . '/tags')
          endif
        endif
      catch
        echom 'can not delete tags'
        return
      endtry

      " tagファイルを作成
      if has('win32')
        echom 'up'
        call s:system_async("CD " . l:project . " && ctags -R", 's:GeneratedProjectTag')
      else
        call s:system_async("cd " . l:project . " | ctags -R", 's:GeneratedProjectTag')
      endif
    else
      echom 'nnot found rails project'
    endif
  endfunction

  function! s:GeneratedProjectTag()
    echom 'tag generate!!!'
  endfunction
  autocmd MyAutoCmd BufEnter,WinEnter * call s:CheckProject()

  " nnoremap [ctag]u :<C-u>call UpdateTags()<CR>
  nnoremap [ctag]j <C-]>
  nnoremap [ctag]k <C-t>
  nnoremap [ctag]l :<C-u>tselect<CR>
  nnoremap [ctag]; :<C-u>tags<CR>
  nnoremap [ctag]v :vsp<CR>:exe("tjump " . expand("<cword>"))<CR>
  nnoremap [ctag]s :exe("stj " . expand("<cword>"))<CR>
  vnoremap [ctag]j g<C-]>
" + }}}
