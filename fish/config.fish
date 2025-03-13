# ~/.config/fish/config.fish
export EDITOR="vim"
export PATH="$HOME/.emacs.d/bin:$PATH"
alias lsa="exa -al --color=always --group-directories-first"
alias nano="vim"

starship init fish | source

### FZF ###
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c  = fzf cd
fzf --fish | source

fastfetch
