# source {{{

typeset -U path cdpath fpath manpath

# EDITOR
export EDITOR=vim

# LANG
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

# scriptへのパス
path=( ${path} $HOME/Dropbox/dotfiles/script(N-/) $HOME/.script.local(N-/) )

# .zshrcの読み込み
[[ -f ~/.zshrc.alias ]] && source ~/.zshrc.alias
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# パス周りでおかしければ...
#   http://pastak.hatenablog.com/entry/2014/02/21/025836

# for homebrew
path=(/usr/local/bin ${path})
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_BREWFILE="$HOME/Dropbox/dotfiles/Brewfile"

# for anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
for D in `ls $HOME/.anyenv/envs`
do
  export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
done

# for direnv
# eval "$(direnv hook zsh)"

# for cool-peco
# source $HOME/Dropbox/dotfiles/cool-peco/cool-peco

# for plenv
unset -f _plenv

# zsh-completions and zsh-syntax-highlighting
# fpath=(/usr/local/share/zsh-completions(N-/) $fpath)
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh completions
# fpath=( ${fpath} $HOME/Dropbox/dotfiles/zsh/zsh-perl-completions(N-/) )

# Google Cloud SDK
# export PATH=/usr/local/google-cloud-sdk/bin:$PATH

autoload -U compinit
compinit -u

# source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
# source '/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
# }}}

# option {{{
setopt auto_cd # 入力したコマンドが存在せず, ディレクトリ名が一致する場合cd
setopt auto_pushd # cdでTabを押すとdir listを表示
setopt pushd_ignore_dups # ディレクトリスタックに同じディレクトリを追加しない
setopt correct # スペルチェック
setopt list_packed # 補完候補リストを詰めて表示
setopt list_types # auto_listの補完候補一覧で, ファイルの種別を表示
setopt auto_list # 補完候補が複数ある場合一覧表示
setopt magic_equal_subst # '--prefix='の'='以降も補完
setopt auto_param_slash # ディレクト名補完で末尾の'/'を挿入
setopt brace_ccl # {a-c}をa b cに展開
setopt auto_menu # 補完キー連打で補完候補を自動補完
setopt nolistbeep # ビープを鳴らさない
setopt multios # 複数のリダイレクトやパイプなど必要に応じてtee/catが使われる
setopt noautoremoveslash # 最後がディレクトリで終わる場合, '/'を自動的に除去しない
#setopt extended_glob
setopt ignoreeof # Ctrl + dでシェル閉じない
setopt nobeep
# }}}

# zstyle {{{
# 矢印キー補完
zstyle ':completion:*:default' menu select

# セパレータ
zstyle ':completion:*' list-separator '=>'
zstyle ':completion:*:manuals' separate-sections true

# 色付きで補完
zstyle ':completion:*' list-colors di=34 fi=0

# sudoも補完の対象に
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# add
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
# }}}

# 色の定義 {{{
autoload colors
colors
DEFAULT=$'%{\e[0;0m%}'
RESET="%{${reset_color}%}"
WHITE="%{${fg[white]}%}"
GREEN="%{${fg[green]}%}"
BOLD_GREEN="%{${fg_bold[green]}%}"
BLUE="%{${fg[blue]}%}"
BOLD_BLUE="%{${fg_bold[blue]}%}"
RED="%{${fg[red]}%}"
BOLD_RED="%{${fg_bold[red]}%}"
CYAN="%{${fg[cyan]}%}"
BOLD_CYAN="%{${fg_bold[cyan]}%}"
YELLOW="%{${fg[yellow]}%}"
BOLD_YELLOW="%{${fg_bold[yellow]}%}"
MAGENTA="%{${fg[magenta]}%}"
BOLD_MAGENTA="%{${fg_bold[magenta]}%}"
# }}}

# プロンプト {{{
# プロンプトを表示するたびにプロンプト文字列を評価, 置換
setopt prompt_subst

PROMPT2="> "
PROMPT="${BLUE}[%5v]${RESET} ${GREEN}%~${RESET}
$ "

precmd() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    psvar[2]=$(_plenv_perl_version)
    psvar[3]=$(_rbenv_ruby_version)
    psvar[4]=$(_pyenv_python_version)
    psvar[5]=`echo $USER`
    psvar[6]=$(_ndenv_node_version)
}

[[ -f ~/.zshrc.prompt ]] && source ~/.zshrc.prompt

RPROMPT="${BLUE}[%2(v|pl:%2v|) %3(v|rb:%3v|) %4(v|py:%4v|) %6(v|nd:%6v|)]${RESET}%1(v|${GREEN}%1v${RESET}|)"
SPROMPT="'%r' is correct? ([n]o, [y]es, [a]bort, [e]dit):"

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# plenv {{{
#   http://unknownplace.org/memo/2013/01/24/1/
function _plenv_perl_version() {
    local dir=$PWD

    [[ -n $PLENV_VERSION ]] && { echo $PLENV_VERSION | tr -d '\n'; echo "(e)"; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.perl-version" ]]; then
            head -n 1 "$dir/.perl-version" | tr -d '\n'
            echo "(l)"
            return
        fi
        dir=$dir:h
    done

    local plenv_home=$PLENV_HOME
    [[ -z $PLENV_HOME && -n $HOME ]] && plenv_home="$HOME/.anyenv/envs/plenv"

    if [[ -f "$plenv_home/version" ]]; then
        head -n 1 "$plenv_home/version" | tr -d '\n'
        echo "(g)"
        return
    fi

    echo 'system'
}
# }}}

# pyenv {{{
function _pyenv_python_version() {
    local dir=$PWD

    [[ -n $PYENV_VERSION ]] && { echo $PYENV_VERSION | tr -d '\n'; echo "(e)"; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.python-version" ]]; then
            head -n 1 "$dir/.python-version" | tr -d '\n'
            echo "(l)"
            return
        fi
        dir=$dir:h
    done

    local pyenv_home=$PYENV_HOME
    [[ -z $PYENV_HOME && -n $HOME ]] && pyenv_home="$HOME/.anyenv/envs/pyenv"

    if [[ -f "$pyenv_home/version" ]]; then
        head -n 1 "$pyenv_home/version" | tr -d '\n'
        echo "(g)"
        return
    fi

    echo 'system'
}
# }}}

# rbenv {{{
function _rbenv_ruby_version() {
    local dir=$PWD

    [[ -n $RBENV_VERSION ]] && { echo $RBENV_VERSION | tr -d '\n'; echo "(e)"; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.ruby-version" ]]; then
            head -n 1 "$dir/.ruby-version" | tr -d '\n'
            echo "(l)"
            return
        fi
        dir=$dir:h
    done

    local rbenv_home=$RBENV_HOME
    [[ -z $RBENV_HOME && -n $HOME ]] && rbenv_home="$HOME/.anyenv/envs/rbenv"

    if [[ -f "$rbenv_home/version" ]]; then
        head -n 1 "$rbenv_home/version" | tr -d '\n'
        echo "(g)"
        return
    fi

    echo 'system'
}
# }}}

# ndenv {{{
function _ndenv_node_version() {
    local dir=$PWD

    [[ -n $NDENV_VERSION ]] && { echo $NDENV_VERSION | tr -d '\n'; echo "(e)"; return }

    while [[ -n $dir && $dir != "/" && $dir != "." ]]; do
        if [[ -f "$dir/.node-version" ]]; then
            head -n 1 "$dir/.node-version" | tr -d '\n'
            echo "(l)"
            return
        fi
        dir=$dir:h
    done

    local ndenv_home=$NDENV_HOME
    [[ -z $NDENV_HOME && -n $HOME ]] && ndenv_home="$HOME/.anyenv/envs/ndenv"

    if [[ -f "$ndenv_home/version" ]]; then
        head -n 1 "$ndenv_home/version" | tr -d '\n'
        echo "(g)"
        return
    fi

    echo 'system'
}
# }}}

# VCSの情報を表示 {{{
#   参照: http://d.hatena.ne.jp/mollifier/20100906/p1
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # この check-for-changes が今回の設定するところ
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
    zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
    zstyle ':vcs_info:git:*' formats '(%s)-[%b%c%u]'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a%c%u]'
fi
# }}}
# }}}

# 履歴 {{{
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000  # メモリに展開する履歴数
SAVEHIST=500000 # 保存する履歴数
setopt extended_history # 履歴ファイルに時刻記録
setopt share_history    # historyの共有
# }}}

# vim mode {{{ 
zle -A .backward-delete-char vi-backward-delete-char
# }}}

# tmux {{{
if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && which tmux > /dev/null; then
    if ( tmux has-session ); then
        session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
            if [ -n "$session" ]; then
            echo "Attache tmux session $session."
                tmux attach-session -t $session
        else
            echo "Session has been already attached."
            tmux list-sessions
            fi
    else
        echo "Create new tmux session."
        tmux
    fi
fi

if [[ -n $TMUX ]]; then
    function _tmux_alert() {
        echo -n "\a"
    }
    add-zsh-hook precmd _tmux_alert
fi
if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
            tmux attach && echo "tmux attached session "
        else
            tmux new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi
# }}}

# keybind/command {{{
bindkey -v # viライクなキーバインド設定

# cd {{{
function chpwd() {
  ls
}
function cdup() {
  echo
  cd ..
  ls
  zle reset-prompt
}
zle -N cdup
bindkey '^\^' cdup
# }}}

# sandbox {{{
function sandbox() {
  cd ~/Dropbox/sandbox
}
alias sb=sandbox
# }}}

# pmver {{{
function pmver ()
{
    do_cd=;
    if [ "$1" = '-cd' ]; then
        do_cd=1;
        shift;
    fi;
    module=$1;
    perl -M${module} -e "print \$${module}::VERSION,\"\n\"";
    fullpath=$(
        perldoc -ml ${module} 2>/dev/null
        [ $? -eq  255 ] && perldoc -l ${module}
    );
    echo $fullpath;
    if [ "$do_cd" = '1' ]; then
        cd $(dirname $fullpath);
    fi
}
# }}}

# peco {{{
stty stop undef
function peco-src () {
    local selected_dir=$(ghq list --full-path | peco-source-filter -p2t | peco --query "$LBUFFER" --prompt "SOURCE >" | peco-source-filter -t2p)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^S' peco-src

function peco-select-history() {
    cool-peco history
}
zle -N peco-select-history
bindkey "^r" peco-select-history

function peco-pkill() {
  for pid in `ps aux | peco --prompt "PROCESS >" | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="peco-pkill"
alias pps="cool-peco ps"

function peco-ssh() {
  ssh-config-generator
  SSH=$(grep "^\s*Host " ~/.ssh/config | sed s/"[\s ]*Host "// | grep -v "^\*$" | sort | peco --prompt "SERVER >")
  echo $SSH
  ssh $SSH
}
alias ss="peco-ssh"

function peco-path() {
  local filepath="$(find . | grep -v '/\.' | peco --prompt 'PATH >')"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$filepath"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}

zle -N peco-path
bindkey '^e' peco-path
# }}}
# }}}

# 履歴検索 {{{
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^h" history-beginning-search-backward-end
bindkey "^l" history-beginning-search-forward-end

# インクリメンタルサーチ
bindkey '^j' history-incremental-search-backward
bindkey '^k' history-incremental-search-forward

setopt hist_ignore_all_dups # 同一コマンドがある場合, 古いものを削除
setopt hist_no_store        # historyコマンドは履歴に保存しない
setopt hist_expand          # 補完時にヒストリを自動展開
# }}}

#power_line {{{
# PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
# export PATH=$PATH:~/.local/bin
# powerline-daemon -q
# . ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
#}}}
