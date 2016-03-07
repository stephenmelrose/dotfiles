# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the history file, don't overwrite it
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="[%F %T] "
shopt -s histappend

# Path
export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS

# Shortcuts
alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'"
alias gits='git status'

# Using 256 colours based on
# http://misc.flogisoft.com/bash/tip_colors_and_formatting

# Colour constants
reset=0
bold=1

# Generate a chained colour
function clr {
    local clr="${reset}"
    for param in "$@"
    do
        local clr="${clr};${param}"
    done
    echo "\[\e[${clr}m\]"
}

# Generate text colour
function tclr {
    if [ "${1}" != "" ]; then
        echo "38;5;${1}"
    fi
}

# Generate background colour
function bclr {
    if [ "${1}" != "" ]; then
        echo "48;5;${1}"
    fi
}

# Set defaults
host="$(clr ${bold} $(tclr 75))" # Blue
path="$(clr ${bold} $(tclr 254))" # White
git=$(clr ${bold} 33) # Yellow

# Shortcut for git_ps1
function gitPrompt {
    command -v __git_ps1 > /dev/null && __git_ps1
}

# PS1
export PS1="${host}\u${path} \w${git}\$(gitPrompt)$(clr) \$ "

# Local settings
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi
