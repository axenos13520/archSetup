#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$HOME/Android/Sdk
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:/usr/scripts:~/.local/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PYENV_ROOT/bin"
export EDITOR="vim"

alias ls="ls -l --color=auto"
alias p="python main.py"
alias live-server="live-server --no-browser"
alias rw="pkill -SIGUSR2 waybar"
alias x="exit"

function forti {
    sudo openfortivpn -c "/etc/openfortivpn/$1"
}

eval "$(pyenv init -)"

if [[ $(ps -p $(ps -p $$ -o ppid=) -o args=) == "foot" ]]; then
    fastfetch
fi
