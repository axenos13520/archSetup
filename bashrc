#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$PATH:~/.local/bin"

alias ls="ls -l --color=auto"
alias p="python main.py"
alias rw="pkill -SIGUSR2 waybar"
alias live-server="live-server --no-browser"
alias ngrok="ngrok http --url=mammoth-welcomed-happily.ngrok-free.app $1"
