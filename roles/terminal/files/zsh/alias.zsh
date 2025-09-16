# To temporarily bypass an alias, we precede the command with a \
alias vim='nvim'
alias vi='nvim'
alias aon='NVIM_APPNAME=aon nvim'

alias cat='bat'

# Alias's to modified commands
alias mkdir='mkdir -p'
alias ping='ping -c 10'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for directory listing commands
alias ls='ls -lAFh --color=always' # add colors and file type extensions
alias lt='lsd -lA --tree'
alias ltc='lsd -lA --tree --classic'

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'
