"--------------------
" 基本的な設定
"--------------------
set notitle

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

syntax enable

"ヤンクでクリップボードにコピーできるように
set clipboard=unnamedplus
set clipboard=autoselect

""新しい行のインデントを現在行と同じにする
set autoindent

colorscheme jellybeans

nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

noremap ; :
noremap : ;

autocmd! FileType html setlocal shiftwidth=2
autocmd! FileType javascript setlocal shiftwidth=2
autocmd! FileType css setlocal shiftwidth=2
autocmd! FileType markdown setlocal shiftwidth=2
autocmd! FileType markdown hi! def link markdownItalic Normal
" 末尾の空白削除
" autocmd BufWritePre * :%s/\s\+$//ge
set shiftwidth=4

" execute "set colorcolumn=" . join(range(131, 9999), ',')

"ステータスラインを常に表示
set laststatus=2
set statusline=%F%m%r%h%w%=\ %{fugitive#statusline()}\ [%{&ff}:%{&fileencoding}]\ [%Y]\ [%04l,%04v]\ [%l/%L]\ %{strftime(\"%Y/%m/%d\ %H:%M:%S\")}

"ルーラーを表示
set ruler

"コメントを改行で自動挿入しない
set formatoptions-=ro

"入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <ESC>

" インサートモードでバックスペース有効に
set backspace=indent,eol,start

"w!!でスーパーユーザとして保存（sudoが使える環境限定)
cmap w!! w !sudo tee > /dev/null %

"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/vimbackup

"vi互換をオフする
set nocompatible

"相対行番号を有効にする
" set relativenumber
set number
set cursorline
hi clear CursorLine
hi CursorLineNr term=bold   cterm=NONE ctermfg=228 ctermbg=NONE

"スワップファイル用のディレクトリを指定する
set directory=$HOME/vimbackup

"タブの代わりに空白文字を指定する
set expandtab

"タブ幅の設定
set tabstop=2

"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"検索の時に大文字小文字区別しない
set ignorecase
"検索の時に大文字が含まれている場合は区別して検索
set smartcase
"検索結果をハイライトする
set hlsearch

"インクリメンタルサーチを行う
set incsearch

"perlお決まり公文
inoremap ,ff #!/usr/bin/env perl<CR>use strict;<CR>use warnings;

"行番号を表示する
" set number

" vimdiff色設定
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

"自動で括弧を閉じる
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

"改行時に入力された行の末尾にあわせて次の行のインデントを増減する
set smartindent

"新しい行を作った時に高度な自動インデントを行う
set smarttab

" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh

" 検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>

" vimgrepやgrep した際に、cwindowしてしまう
autocmd QuickFixCmdPost *grep* cwindow

" エスケープシーケンスの表示 tab eol
" set list

" 全角スペースの表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkGray gui=reverse guifg=DarkGray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        "ZenkakuSpace をカラーファイルで設定するなら、
        "次の行をコメントアウト
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif


"
"ref.vim
""
" vim-ref のバッファを q で閉じられるようにする
autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>

"webdictサイトの設定
let g:ref_source_webdict_sites = {
\   'je': {
\     'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
\   },
\   'ej': {
\     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
\   },
\   'wiki': {
\     'url': 'http://ja.wikipedia.org/wiki/%s',
\   },
\ }

"デフォルトサイト
let g:ref_source_webdict_sites.default = 'je'

"出力に対するフィルタ。最初の数行を削除
function! g:ref_source_webdict_sites.je.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  return join(split(a:output, "\n")[17 :], "\n")
endfunction

nmap <Leader>rj :<C-u>Ref webdict je<Space>
nmap <Leader>re :<C-u>Ref webdict ej<Space>


"Previm
"
""
let g:previm_open_cmd = ""
let g:previm_enable_realtime = 1
""let g:previm_disable_default_css = 0
let g:previm_custom_css_path = '/Users/Kentaro/bootstrap/css/bootstrap.css'
augroup PrevimSettings
    autocmd!
	    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"gips-vim
let g:gips_reading_txt = '$HOME/.vim/bundle/gips-vim/autoload/dict/tsundere.txt'


"
" NeoBundle
"
"
" neobundle settings {{{
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    " vim からコマンド呼び出しているだけ neobundle.vim のクローン
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

NeoBundleFetch 'Shougo/neobundle.vim'
" NeoBundle よるプラグインのロードと各プラグインの初期化
" 読み込むプラグインの指定

" vimmer養成ギプス
"NeoBundle 'modsound/gips-vim.git'
" NeoBundle 'plasticboy/vim-markdown'
" NeoBundle 'tukiyo/previm'
NeoBundle 'scrooloose/nerdtree'
nnoremap <silent><C-e> :NERDTreeToggle<CR>
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kana/vim-submode'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler.vim'
" Solorized
NeoBundle 'altercation/vim-colors-solarized'
"Ruby向けにendを自動挿入
NeoBundle 'tpope/vim-endwise'
" コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'
" vim-ref
NeoBundle 'thinca/vim-ref'
"quickrun
NeoBundle 'thinca/vim-quickrun'
"補完機能
NeoBundle 'davidhalter/jedi-vim'
"コメントアウト
NeoBundle "tyru/caw.vim.git"
" テキストを整列してくれるやる
NeoBundle 'junegunn/vim-easy-align'
" XSLATE
NeoBundle 'vim-perl/vim-perl'
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" html/css入力補助プラグイン
NeoBundle 'mattn/emmet-vim'
" powerline
NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}
NeoBundle 'Lokaltog/powerline-fontpatcher'
"選択範囲を囲む
NeoBundle 'tpope/vim-surround'
"ふぁいらーー
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
"ヤンク履歴を保持してくれる
NeoBundle 'LeafCage/yankround.vim'
" vueのシンタックス
NeoBundle "pangloss/vim-javascript"
NeoBundle "mxw/vim-jsx"
autocmd BufNewFile,BufRead *.{html,htm,vue*} set filetype=html
" yankround.vim {{{
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 100
nnoremap <Leader><C-p> :<C-u>Unite yankround<CR>
"}}}
" memo取るマン
NeoBundle 'glidenote/memolist.vim'
" coffeescript syntax
NeoBundle 'kchmck/vim-coffee-script'
" memolist {{{
let g:memolist_path = expand('~/memo')
let g:memolist_gfixgrep = 1
let g:memolist_unite = 1
let g:memolist_unite_option = "-vertical -start-insert"
nnoremap mn  :MemoNew<CR>
nnoremap ml  :MemoList<CR>
nnoremap mg  :MemoGrep<CR>
"}}}

nmap ga <Plug>(EasyAlign)
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)
"ifとかの終了宣言を自動挿入
NeoBundleLazy 'tpope/vim-endwise', {
  \ 'autoload' : { 'insert' : 1,}}

" シンタックスチェック
" NeoBundle 'scrooloose/syntastic'
" let g:syntastic_enable_signs=1
" let g:syntastic_auto_loc_list=2


"""オートコンプリート"""
" neocomplcache for auto completing
NeoBundle 'Shougo/neocomplcache'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : ''
            \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
""""""""""""

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on
