export current_network=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed -e "s/^  *SSID: //p" -e d)
if [[ $current_network == "clear-corporate" ]]; then export http_proxy='http://www-proxy.us.oracle.com:80'; fi
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$http_proxy
export http_proxy=$http_proxy
export https_proxy=$http_proxy
export proxy=$http_proxy
export proxy_host=`echo $http_proxy | awk -F[/:] '{print $4}'`
export proxy_port=`echo $http_proxy | awk -F[/:] '{print $5}'`

export PATH=/usr/local/Cellar/findutils/4.6.0/bin:$PATH
export PATH=$PATH:$(find $HOME/.config/Scripts -type d | xargs | sed 's# #:#g')

source git-completion
source gradle-completion

alias ls="ls -G"
alias ll="ls -lG"
alias f="fzf --height 40% --reverse --preview 'file {}' --preview-window down:1"
alias vim='/usr/local/Cellar/macvim/8.1-155/bin/vim'
alias gradle='gradle -Dhttp.proxyHost=$proxy_host -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_host -Dhttps.proxyPort=$proxy_port'

export PATH="$HOME/.cargo/bin:$PATH"
