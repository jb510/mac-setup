# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"
#ZSH_THEME="cobalt2"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github gulp httpie osx mosh rsync ssh-agent sublime wp-cli yarn z zsh-navigation-tools)

source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/plugins/z.sh

source ~/.bash_profile

# Customize to your needs...
# append
path+=('/usr/bin')
path+=('/usr/local/bin')
path+=('/usr/local/sbin')
path+=('~/pear/bin')
path+=('~/pear/share/pear')
path+=('~/bin')
path+=('~/.composer/vendor/bin')
path+=('~/.node/bin')
path+=('/usr/bin/java')
# export to sub-processes (make it inherited by child processes)
export PATH
source ~/.gulp-autocompletion-zsh/gulp-autocompletion.zsh

### Aliases 
alias p8="ping -c 5 -i .5 8.8.8.8 && ping -i 5 8.8.8.8"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias wgetc="wget --continue"
alias npmnuke="rm -rf node_modules; rm package-lock.json; npm cache clean --force; npm install;"
alias hh="http --headers"
source /Users/jon/.gulp-autocompletion-zsh/gulp-autocompletion.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
#export PATH="/usr/local/opt/node@8/bin:$PATH"
