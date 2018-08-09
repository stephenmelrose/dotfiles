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
export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home"

# Override existing commands
alias grep='grep --color=auto'

# Shortcuts
alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'"
alias cpgrep="grep --exclude-dir=\"storage\""
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

# Shortcut for git_ps1
function gitPrompt {
    command -v __git_ps1 > /dev/null && __git_ps1
}

# PS1
export PS1="${host}\u${path} \w\[\e[1;0;33m\]\$(gitPrompt)$(clr) \$ "

# Local settings
if [ -f ~/.localrc ]; then
    source ~/.localrc
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/steve/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/Users/steve/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/steve/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/steve/Downloads/google-cloud-sdk/completion.bash.inc'; fi
export GPG_TTY=$(tty)
