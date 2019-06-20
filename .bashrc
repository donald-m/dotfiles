# load functions
source ~/.functions.sh
# Use config command to manage dotfiles git repo
alias config='/usr/local/bin/git --git-dir=/Users/donald/.cfg/ --work-tree=/Users/donald'
# Include phpcs (PHP Code Sniffer)
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Include path for AWS CLI
export PATH="$HOME/Library/Python/3.7/bin:$PATH"

# git autocompletion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
# some nice colors for git
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
