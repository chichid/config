alias vim=nvim

export CLICOLOR=1
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

precmd () {
  echo -en "\033]0;$(basename `pwd`)\a"
}

