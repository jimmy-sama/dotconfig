function env_vault.load(){
  echo "Loading env vault..."
  source =(ansible-vault view ${ENV_VAULT})
}

function env_vault.edit(){
  ansible-vault edit ${ENV_VAULT}
}

#Automatically do an ls after each cd
cd () {
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

function whatsmyip() {
	# Dumps a list of all IP addresses for every device
	# /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';
	
	### Old commands
	# Internal IP Lookup
	#echo -n "Internal IP: " ; /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'
#
#	# External IP Lookup
	#echo -n "External IP: " ; wget http://smart-ip.net/myip -O - -q
	
	# Internal IP Lookup.
	if [ -e /sbin/ip ]; then
		echo -n "Internal IP: " ; /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
	else
		echo -n "Internal IP: " ; /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
	fi

	# External IP Lookup 
	echo -n "External IP: " ; curl -s ifconfig.me
}

function learn_py() {
  builtin cd ~/GitHub/python_collection/hundred-days/
  if [ -e .venv ]; then
    source .venv/bin/activate
  else
    python3 -m venv .venv
    source .venv/bin/activate
    python -m pip install -r requirements.txt
  fi
} 
