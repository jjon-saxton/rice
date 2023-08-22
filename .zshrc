# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

export EDITOR="vim"
export PATH="$HOME/.emacs.d/bin:$PATH"
alias lsa="exa -al --color=always --group-directories-first"
alias nano="vim"
alias package="$HOME/simple_yay.sh"
alias pac="package"
alias startq="qtile start -b wayland"

if [ $SSH_CLIENT ] || [ $SSH_TTY ] || [ $DISPLAY ];
then
   neofetch
else
   qtile start -b wayland
fi
