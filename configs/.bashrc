#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# git branch name
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1="[\u@: \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]]$ "
# PS1='[\u@\h \W]\$ '

# added
alias vi="vim"
alias code="code --ozone-platform=wayland"
alias install="sudo pacman -S"
alias remove="sudo pacman -R"
alias update="sudo pacman -Syu && sudo yay -Syu"
alias clean="sudo pacman -Sc && sudo pacman -Rns -"
alias fd="cd ~ && cd \$(find * . -type d | fzf)"
alias shutdown="shutdown 0"
ff() {
	local selected_file
	selected_file=$(find ~ -type f | fzf) && vim "$selected_file"
}
export EDITOR="vim"
export VISUAL="vim"
