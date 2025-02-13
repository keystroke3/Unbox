autoload -Uz add-zsh-hook
setopt PROMPT_SUBST
export VIRTUAL_ENV_DISABLE_PROMPT=1
rosewater=$'\e[38;5;217m'
flamingo=$'\e[38;5;210m'
pink=$'\e[38;5;211m'
mauve=$'\e[38;5;176m'
red=$'\e[38;5;168m'
maroon=$'\e[38;5;132m'
peach=$'\e[38;5;209m'
yellow=$'\e[38;5;180m'
green=$'\e[38;5;114m'
teal=$'\e[38;5;116m'
sky=$'\e[38;5;117m'
sapphire=$'\e[38;5;74m'
blue=$'\e[38;5;110m'
lavender=$'\e[38;5;147m'
text=$'\e[38;5;188m'
subtext1=$'\e[38;5;145m'
subtext0=$'\e[38;5;102m'
overlay2=$'\e[38;5;59m'
overlay1=$'\e[38;5;66m'
overlay0=$'\e[38;5;60m'
surface2=$'\e[38;5;242m'
surface1=$'\e[38;5;239m'
surface0=$'\e[38;5;236m'
base=$'\e[38;5;234m'
mantle=$'\e[38;5;233m'
crust=$'\e[38;5;232m'
reset=$'\e[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# Variable to store command start time
typeset -g command_start_time

# Function to be called before each command
preexec() {
    command_start_time=$SECONDS
}

# Function to be called after each command
precmd() {
    # Calculate command duration
    cmd_status=$?
    if [ -n "$command_start_time" ]; then
        local command_duration=$((SECONDS - command_start_time))
        unset command_start_time
        # Format duration
        if ((command_duration >= 60)); then
            local mins=$((command_duration / 60))
            local secs=$((command_duration % 60))
            command_time_info="${subtext1}took ${mins}m${secs}s"
        elif ((command_duration >= 5)); then  # Only show if command took more than 5 seconds
            command_time_info="${subtext1}took ${command_duration}s"
        else
            command_time_info=""
        fi
    else
        command_time_info=""
    fi
}

git_info() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        local dirty=""
        [[ -n "$(git status --porcelain 2>/dev/null)" ]] && dirty="*"
        echo "$normal on$bold $maroon  $branch$dirty"
    fi
}

venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "$yellow (v$(/usr/bin/env python --version | cut -d' ' -f2) $(basename "$VIRTUAL_ENV"))"
    fi
}

screen_info(){
    if [[ -n "$STY" ]]; then
        echo "%{$subtext1%}[$STY:$WINDOW] %{$reset%}"
    fi
}

prompt_char() {
    [[ $cmd_status -eq 0 ]] && echo "%{$green%}❯" || echo "%{$red%}❯"
}

PROMPT='$(screen_info)%{$bold%}%{$mauve%}%n@%m %{$normal%}in%{$bold%} %{$teal%}%1~$(git_info)$(venv_info) ${command_time_info}
$(prompt_char) %{$text%}'


source $HOME/.aliases
HISTFILE=$HOME/.zhistory
HISTSIZE=20000
SAVEHIST=15000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt autocd extendedglob
bindkey -v
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# enable this for automatic virtual env switching
# source $HOME/.zsh/zsh-autoswitch-virtualenv/autoswitch_virtualenv.plugin.zsh
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
source $HOME/.zsh/zsh-autoswitch-virtualenv/autoswitch_virtualenv.plugin.zsh
export PATH="/home/ubuntu/.local/bin:$PATH"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export GPG_TTY=$(tty)
#LS_COLOR='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
#export LS_COLORa
stty -ixon
