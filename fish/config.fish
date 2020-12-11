# General 
cd ~
set fish_greeting

# LS
set -x LS_COLORS "$LS_COLORS:ow=1;34:tw=1;34:"

#Key Bindings
bind \el 'clear; commandline -f repaint'
bind \ek 'clear; commandline -f repaint'
bind \t forward-word
bind \e\[F\x7F backward-kill-word

