# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the history file, don't overwrite it
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Path
export PATH=$PATH:./node_modules/.bin

# Override existing commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Shortcuts
alias c="composer"
alias gits='git status'
alias prettyjson='python -mjson.tool'
alias tarzip='tar -czf'
alias tarunzip="tar -zxf"

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

# Purple for Sky Vagrant VM
if [ `hostname` == "skybetdev" ]; then
    host="$(clr ${bold} $(tclr 183))"
fi

# Yellow for digidev1/gitlab
if [ `hostname` == "digidev1" -o `hostname` == "gitlab" ]; then
    host="$(clr ${bold} $(tclr 220))"
fi

# Red for root
if [ "${UID}" -eq "0" ]; then
    host="$(clr ${bold} $(bclr 160))"
fi

# Shortcut for git_ps1
function gitPrompt {
    command -v __git_ps1 > /dev/null && __git_ps1
}

# PS1
export PS1="${host}\u@\h${path} \w${git}\$(gitPrompt)$(clr) \$ "

# Local settings
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi
