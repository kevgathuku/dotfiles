
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

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
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(git textmate ruby lighthouse)
plugins=(git direnv brew sublime zoxide python gitignore mosh nvm tmux rbenv pyenv npm colored-man-pages bundler zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

platform='unknown'
unamestr=`uname`

if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='macos'
fi

if [[ $platform == 'linux' ]]; then
	# Configuration for linux
	# TODO
elif [[ $platform == 'macos' ]]; then
	# Configuration for MAC OS

	# Haskell
	export PATH="$HOME/Library/Haskell/bin:$PATH"

	# heroku autocomplete setup
	HEROKU_AC_ZSH_SETUP_PATH=/Users/kevin/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

	# asdf
	. $(brew --prefix asdf)/asdf.sh

	export LDFLAGS="-L/usr/local/opt/icu4c/lib"
fi

# Set Postgres 11 as the default
export PATH="/opt/homebrew/opt/postgresql@11/bin:$PATH"

export LDFLAGS="-L/opt/homebrew/opt/postgresql@11/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@11/include"

# Add Cargo Packages to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# User configuration
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

alias diff="colordiff"
alias pipgrep="pip freeze | grep "
alias targ="tar zxf "
alias tarz="tar jxf "
alias gdh="git diff HEAD"
alias gds="git diff --staged -M"
alias zshconfig="vim ~/.zshrc"
alias sourcerc="source ~/.zshrc"
alias bubg='brew update && brew upgrade'
alias pip='pip3'
alias gcsmg='gcmsg'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Delete already merged branches
alias gdm='git branch --merged | grep -v "\*" | egrep -v "master|develop" | xargs -n 1 git branch -d'

# Alias gwch to the much shorter gwc
alias gwc='gwch'

# Append pipenv run to python
alias prp="pipenv run python"

# Configure the Global Editor
export EDITOR=`which vim`

# Go
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add composer to path
export PATH="$PATH:$HOME/.composer/vendor/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kevin/tmp/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/kevin/tmp/google-cloud-sdk/path.zsh.inc'; fi

# GPG signing commits
export GPG_TTY=$(tty)

# Let pipenv create a virtualenv inside the project’s directory
export PIPENV_VENV_IN_PROJECT=1

###-tns-completion-start-###
if [ -f /Users/kevin/.tnsrc ]; then 
    source /Users/kevin/.tnsrc 
fi
###-tns-completion-end-###

export PATH="/Users/kevin/.local/share/solana/install/active_release/bin:$PATH"

# https://github.com/starship/starship
eval "$(starship init zsh)"

# opam configuration
[[ ! -r /Users/kevin/.opam/opam-init/init.zsh ]] || source /Users/kevin/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null


#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
