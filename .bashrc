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

# Generate a PS1 seperator
sep="$(echo -e '\xee\x82\xb0')"
sepThin="$(echo -e '\xee\x82\xb1')"
function genPs1Sep {
    local fromClr=${1}
    local toClr=${2}
    if [ "${fromClr}" != "${toClr}" ]; then
        local sep=${sep}
    else
        local sep=${sepThin}
        local fromClr=${3}
    fi
    local sepClr=$(clr $(tclr ${fromClr}) $(bclr ${toClr}))
    echo "${sepClr}${sep}"
}

# User@Host colours (blue by default)
hostTxt=254
hostBg=25

# Path colours
pathTxt=254
pathBg=235

# Git colours
gitTxt=227
gitBg=238

# End colours
endTxt=${pathTxt}
endBg=${pathBg}

# Purple for Sky Vagrant VM
if [ `hostname` == "skybetdev" ]; then
    hostBg=133
fi

# Orange for linodev1
if [ `hostname` == "linodev1" ]; then
    hostTxt=237
    hostBg=220
fi

# Red for root
if [ "${UID}" -eq "0" ]; then
    hostTxt=
    hostBg=160
    pathBg=88
    gitBg=124
    endBg=${pathBg}
fi

# Generate PS1 parts
hostAndPath="$(clr ${bold} $(tclr ${hostTxt}) $(bclr ${hostBg})) \u@\h " # Host
hostAndPath="${hostAndPath}$(genPs1Sep ${hostBg} ${pathBg} ${hostTxt})" # Separator
hostAndPath="${hostAndPath}$(clr $(tclr ${pathTxt}) $(bclr ${pathBg})) \w " # Path
gitStart="$(genPs1Sep ${pathBg} ${gitBg} ${pathTxt})$(clr ${bold} $(tclr ${gitTxt}) $(bclr ${gitBg}))"
gitEnd=" $(genPs1Sep ${gitBg} ${endBg} ${gitTxt})"
noGit="$(genPs1Sep ${pathBg} ${endBg} 243)"
end="$(clr $(tclr ${endTxt}) $(bclr ${endBg})) \$ $(genPs1Sep ${endBg})$(clr ${reset}) "

# Dynamic PS1
function setPs1 {
    local gitPs1=$(command -v __git_ps1 > /dev/null && __git_ps1)
    if [ "${gitPs1}" != "" ]; then
        export PS1="${hostAndPath}${gitStart}${gitPs1}${gitEnd}${end}"
    else
        export PS1="${hostAndPath}${noGit}${end}"
    fi
}
export PROMPT_COMMAND="history -a;setPs1"

# Local settings
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi
