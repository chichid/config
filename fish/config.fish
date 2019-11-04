# General
set -x LS_COLORS "$LS_COLORS:ow=1;34:tw=1;34:"

# Path
set PATH $PATH ~/.config/Scripts
set PATH $PATH (find $HOME/.config/Scripts -maxdepth 2 -type d  | grep -v "node_modules" | xargs | sed 's# #:#g')
set PATH "$HOME/.cargo/bin:$PATH"
set PATH "$HOME/.flutter-sdk/bin:$PATH"

if test (uname) = Darwin
	set PATH /usr/local/Cellar/findutils/4.6.0/bin $PATH
end

# Aliases
if test (uname) = Darwin
	alias fzf="fzf --height 40% --reverse --preview 'file {}' --preview-window down:1"
	alias gradle='gradle -Dhttp.proxyHost=$proxy_host -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_host -Dhttps.proxyPort=$proxy_port'
	alias remote-copy='rsync -av -e ssh --exclude="*/node_modules*"'
	alias lgulp='cpulimit --limit 50 -i gulp'
	alias flutter='export ENABLE_FLUTTER_DESKTOP=true; flutter'
end

# Aliases - Windows
if test (uname) = Windows
	alias flutter="cmd.exe /c flutter"
	alias cargo="cmd.exe /c cargo"
	alias npm="cmd.exe /c npm"
	alias node="cmd.exe /c node"
end

# Proxy config
if test (uname) = Darwin 
	set current_network (/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | sed -e "s/^  *SSID: //p" -e d)
	if test $current_network = "clear-corporate"
		set http_proxy 'http://www-proxy.us.oracle.com:80'
	end
end

set HTTP_PROXY $http_proxy
set HTTPS_PROXY $http_proxy
set export http_proxy $http_proxy
set https_proxy $http_proxy
set proxy $http_proxy
set proxy_host "echo $http_proxy | awk -F[/:] '{print $4}'"
set proxy_port "echo $http_proxy | awk -F[/:] '{print $5}'"

