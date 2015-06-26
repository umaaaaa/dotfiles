"--------------------
"" 基本的な設定
"--------------------
set notitle

set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac

"ヤンクでクリップボードにコピーできるように
set clipboard=unnamed,autoselect

""新しい行のインデントを現在行と同じにする
set autoindent
set shiftwidth=2

"入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <ESC>

"w!!でスーパーユーザとして保存（sudoが使える環境限定)
cmap w!! w !sudo tee > /dev/null %

"バックアップファイルのディレクトリを指定する
"set backupdir=$HOME/vimbackup

"vi互換をオフする
set nocompatible

"相対行番号を有効にする
set relativenumber

"スワップファイル用のディレクトリを指定する
"set directory=$HOME/vimbackup

"タブの代わりに空白文字を指定する
set expandtab

"タブ幅の設定
set tabstop=2

"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"インクリメンタルサーチを行う
set incsearch

"行番号を表示する
set number

"自動で括弧を閉じる
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

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
set list

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

colorscheme desert

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
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'tukiyo/previm' 
"NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kana/vim-submode'
"NeoBundle 'tpope/vim-surround'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler.vim'
"Ruby向けにendを自動挿入
NeoBundle 'tpope/vim-endwise' 
" コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'
" vim-ref 
NeoBundle 'thinca/vim-ref'
"Neobundle 'mfumi/ref-dicts-en'
"Neobundle 'tyru/vim-altercmd'
"quickrun
NeoBundle 'thinca/vim-quickrun'
"補完機能
NeoBundle 'davidhalter/jedi-vim'
"コメントアウト
NeoBundle "tyru/caw.vim.git"
" テキストを整列してくれるやる
NeoBundle 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)

nmap ga <Plug>(EasyAlign)
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)
"ifとかの終了宣言を自動挿入
NeoBundleLazy 'tpope/vim-endwise', {
  \ 'autoload' : { 'insert' : 1,}}

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on
