# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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
plugins=(git python pip django sublime git-flow)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="$HOME/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
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

alias targ="tar zxf "
alias tarz="tar jxf "
alias dropbox="$HOME/.dropbox-dist/dropboxd"
alias gdh="git diff HEAD"
alias gds="git diff --staged -M"
# Delete already merged branches
alias gdm='git branch --merged | grep -v "\*" | egrep -v "master|develop" | xargs -n 1 git branch -d'

# Go
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
source ~/.profile

#Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
source /usr/bin/virtualenvwrapper.sh
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2

#Python Docs
export PYTHONDOCS=/usr/share/doc/python2/html/

#Wine
export WINEPREFIX=.wine # any path to a writable folder on your home directory will do
export WINEARCH="win32"

#Maven
export M2_HOME=/opt/apache-maven/apache-maven-3.2.1
export M2=$M2_HOME/bin
export PATH=$PATH:$M2

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

PATH="$HOME/perl5/bin${PATH+:}$PATH"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB+:}$PERL5LIB"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT+:}$PERL_LOCAL_LIB_ROOT"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/kevin/perl5"; export PERL_MM_OPT;

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# Gitignore
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

#Activate virtualenv on entering directory
check_virtualenv() {
	if [ -e .venv ]; then
		env=`cat .venv`
		if [ "$env" != "${VIRTUAL_ENV##*/}" ]; then
			echo "Found .venv in directory. Calling: workon ${env}"
			workon $env
		fi
	fi
}
venv_cd () {
	builtin cd "$@" && check_virtualenv
}
# Call check_virtualenv in case opening directly into a directory (e.g
# # when opening a new tab in Terminal.app).
check_virtualenv 

alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

