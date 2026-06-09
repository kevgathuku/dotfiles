
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Q pre block. Keep at the top of this file.
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME=""

export DEFAULT_USER=`whoami`

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(git textmate ruby lighthouse)
plugins=(git direnv brew python gitignore mosh tmux rbenv npm colored-man-pages bundler zsh-autopair)

# Skip verification of insecure directories (speeds up startup)
ZSH_DISABLE_COMPFIX=true

# Use history search while typing
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

source $ZSH/oh-my-zsh.sh

# Reduce oh-my-zsh update frequency
zstyle ':omz:update' frequency 30

platform='unknown'
unamestr=`uname`

if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='macos'
fi

if [[ $platform == 'linux' ]]; then
	# Configuration for linux

	# deno
	export DENO_INSTALL="$HOME/.deno"
	export PATH="$DENO_INSTALL/bin:$PATH"

	# kantox
	alias ecs_cli="$HOME/workspace/infrastructure-ecs/cli/bin/dcli"

  # Others
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

  # pnpm
  export PNPM_HOME="$HOME/.local/share/pnpm"

	# guix
	export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
	GUIX_PROFILE="/home/kevingathuku/.guix-profile"
	. "$GUIX_PROFILE/etc/profile"
	unset GUIX_PROFILE
elif [[ $platform == 'macos' ]]; then
	# Configuration for MAC OS

	# Haskell
	export PATH="$HOME/Library/Haskell/bin:$PATH"

  # dune
  export PATH="$HOME/.dune/bin:$PATH"


	export LDFLAGS="-L/usr/local/opt/icu4c/lib"

	# Set Postgres 17 as the default
	export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
	export LDFLAGS="-L/opt/homebrew/opt/postgresql@17/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/postgresql@17/include"

  # pnpm
  export PNPM_HOME="$HOME/Library/pnpm"

  # Homebrew's bin ahead of /usr/bin
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="$(python3 -m site --user-base)/bin:$PATH"

fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add Cargo Packages to PATH
export PATH="$HOME/.cargo/bin:$PATH"
. "$HOME/.cargo/env"

# User configuration
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

alias diff="colordiff"
alias targ="tar zxf "
alias tarz="tar jxf "
alias gdh="git diff HEAD"
alias gds="git diff --staged -M"
alias zshconfig="vim ~/.zshrc"
alias bubg='brew update && brew upgrade'
alias gcsmg='gcmsg'

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
 HISTSIZE=50000
 SAVEHIST=10000

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Toggle Alacritty theme between light and dark
swap-theme() {
  local config="$HOME/.config/alacritty/alacritty.toml"
  # GNU sed (Linux) and BSD sed (macOS) differ in -i syntax
  if [[ "$(uname)" == "Darwin" ]]; then
    local sed_inplace=(sed -i '')
  else
    local sed_inplace=(sed -i)
  fi
  if grep -q 'rose_pine_dawn' "$config"; then
    "${sed_inplace[@]}" 's|rose_pine_dawn|rose_pine_moon|' "$config"
    echo "Switched to dark (Rose Pine Moon)"
  else
    "${sed_inplace[@]}" 's|rose_pine_moon|rose_pine_dawn|' "$config"
    echo "Switched to light (Rose Pine Dawn)"
  fi
}

# Delete already merged branches
alias gdp="git fetch --prune && echo 'Branches with deleted remotes:' && git branch -vv | grep ': gone]'"
alias gdm="git fetch --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs -r  git branch -D"

# Alias gwch to the much shorter gwc
alias gwc='gwch'

# Append pipenv run to python
alias prp="pipenv run python"
alias pipgrep="pip freeze | grep "

# Configure the Global Editor
export EDITOR=`which vim`

# Go
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

# Add Go Lang to PATH 
export PATH=$PATH:/usr/local/go/bin

# Custom npm global PATH
export PATH=$HOME/npm-global/bin:$PATH

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

export GREP_OPTIONS='--color=auto'
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
unset GREP_OPTIONS

# Activate tmux theme
[ -f $HOME/.tmuxline.conf ] && tmux source-file ~/.tmuxline.conf

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,vendor}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# FZF color scheme
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
  --color=fg:#d0d0d0,bg:#121212,hl:#5f87af \
  --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff \
  --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff \
  --color=marker:#87ff00,spinner:#af5fff,header:#87afaf"

# Enable syntax highlighting in vim-ubuntu
export TERM=xterm-256color

# Add composer to path
export PATH="$PATH:$HOME/.composer/vendor/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kevin/tmp/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/kevin/tmp/google-cloud-sdk/path.zsh.inc'; fi

# Ensure coreutils e.g. date are first in the PATH
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"

# GPG signing commits
export GPG_TTY=$(tty)

# Let pipenv create a virtualenv inside the project’s directory
export PIPENV_VENV_IN_PROJECT=1

###-tns-completion-start-###
if [ -f /Users/kevin/.tnsrc ]; then 
    source /Users/kevin/.tnsrc 
fi
###-tns-completion-end-###

# https://github.com/starship/starship
eval "$(starship init zsh)"

# opam configuration
[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh"  > /dev/null 2> /dev/null

# --- Lazy-load NVM ---
export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm on first use
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Lazy-load for node-related commands too
__nvm_lazy_load() {
  unset -f node npm npx corepack yarn pnpm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in node npm npx corepack yarn pnpm; do
  eval "${cmd}(){ __nvm_lazy_load; ${cmd} \"\$@\" }"
done

# Automatic .nvmrc version switching
autoload -U add-zsh-hook
load-nvmrc() {
  # Only run if nvm is already loaded (check if nvm_find_nvmrc function exists)
  if ! type nvm_find_nvmrc &> /dev/null; then
    # Check if .nvmrc exists in current directory or parent
    local nvmrc_path
    nvmrc_path="$(find-up .nvmrc)"

    # If .nvmrc found, load nvm and switch
    if [ -n "$nvmrc_path" ]; then
      # Load nvm first
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    else
      # No .nvmrc, don't load nvm yet (lazy-load will handle it)
      return
    fi
  fi

  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

# Helper function to find file in current or parent directories
find-up() {
  local path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  if [[ -e "$path/$1" ]]; then
    echo "$path/$1"
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc


complete -o nospace -C /opt/homebrew/bin/terraform terraform
fpath+=${ZDOTDIR:-~}/.zsh_functions

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# JDK
export JAVA_HOME=`/usr/libexec/java_home -v 25`

# enhance lein repl with rlwrap
alias lein-repl='rlwrap --always-readline --no-children lein repl'


# bun completions
[ -s "/Users/kevin/.bun/_bun" ] && source "/Users/kevin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
eval "$(mise activate zsh)"

# sml
export PATH=/usr/local/smlnj/bin:"$PATH"

# >>> ara cli (managed by Ara Desktop) >>>
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
# <<< ara cli (managed by Ara Desktop) <<<


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
