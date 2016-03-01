# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

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
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git python pip django sublime git-flow gitignore)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="$HOME/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Add Custom PHP tp PATH
export PATH="/usr/local/opt/php56/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Add Local node_modules path to $PATH
export PATH="./node_modules/.bin:$PATH"

# Add Cabal Packages to PATH
export PATH="$HOME/.cabal/bin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

alias diff="colordiff"
alias pipgrep="pip freeze | grep "
alias targ="tar zxf "
alias tarz="tar jxf "
alias dropbox="$HOME/.dropbox-dist/dropboxd"
alias gdh="git diff HEAD"
alias gds="git diff --staged -M"
alias zshconfig="vim ~/.zshrc"
alias zshrc="source ~/.zshrc"

# mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }

# Delete already merged branches
alias gdm='git branch --merged | grep -v "\*" | egrep -v "master|develop" | xargs -n 1 git branch -d'

# Alias gwch to the much shorter gwc
alias gwc='gwch'

# Mkvirtualenv for Python 3
alias mkvirtualenv3='mkvirtualenv -p $(which python3)'

# Go
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

# PHP Pear PATH
export PATH=$PATH:$HOME/pear/bin

# Postgres PATH
PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

source ~/.profile

# Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper.sh
# Python Docs
export PYTHONDOCS=/usr/share/doc/python2/html/

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH=$PATH:/usr/local/var/rbenv/versions/2.2.3/bin

PATH="$HOME/perl5/bin${PATH+:}$PATH"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}$PERL5LIB"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}$PERL_LOCAL_LIB_ROOT"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# Gitignore
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk

# Lunchy
LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
if [ -f $LUNCHY_DIR/lunchy-completion.zsh ]; then
    . $LUNCHY_DIR/lunchy-completion.zsh
fi

# Ocaml
. /Users/kevgathuku/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export GREP_OPTIONS='--color=auto'
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
unset GREP_OPTIONS

# added by travis gem
[ -f /Users/kevgathuku/.travis/travis.sh ] && source /Users/kevgathuku/.travis/travis.sh

# https://github.com/nvbn/thefuck
eval "$(thefuck --alias)"

# https://github.com/kennethreitz/autoenv
source /usr/local/opt/autoenv/activate.sh
