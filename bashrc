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

p() {
    if [[ -f "CMakeLists.txt" ]]; then
        if [[ -x "./launch.sh" ]]; then
            ./launch.sh
        else
            echo "CMakeLists.txt found, but ./launch.sh is missing or not executable."
        fi
    elif [[ -f "main.py" ]]; then
        python main.py
    else
        echo "No CMakeLists.txt or main.py found in the current directory."
    fi
}

alias ls="ls -lth --color=auto"
alias rw="pkill -SIGUSR2 waybar"
alias x="exit"

eval "$(pyenv init -)"
eval "$(direnv hook bash)"

if [[ $(ps -p $(ps -p $$ -o ppid=) -o args=) == "foot" ]]; then
    fastfetch
fi
