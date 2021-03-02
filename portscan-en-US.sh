#
#	!/usr/bin/env bash	  
#


: '
	-- + usage exmaples + --
#Starting	    		#Domain 	#Port
chmod +x portscan-en-US.sh
./portscan-en-US.sh			127.0.0.1 	1  50
source portscan-en-US.sh		127.0.0.1 	1  50
bash portscan-en-US.sh		192.168.0.1 	80 443
bash portscan-en-US.sh		192.168.0.1 	100 1500
'

#
#
#
#
#

#code

grey="\033[30;1m"
pink="\033[31;1m"
green="\033[32;1m"
orange="\033[33;1m"
white="\033[35;1m"

#domain() {
        if [ "$1" == "" ]; then
                echo "Required domain parameter"; 
        else
                echo -ne "------------------------- $green[$white+$green]$white\033[m\n"
                echo -ne $white"Domain: $1\033[m\n"
        fi
#}

#port() {
        if [[ "$2" != "" && "$3" != "" ]]; then
                echo -ne $white"Port: $2 to $3\033[m\n"
                echo -ne "------------------------- $green[$white+$green]$white\033[m\n"
        else
                echo "Required port parameter"
        fi
#}

function tcp() {
    echo "TCP protocol selected"
    echo ""
    protocol='tcp'
    for port in `seq $2 $3`;
    do
    timeout 0 bash -c "</dev/$protocol/$1/$port" &>/dev/null \
    && echo -ne "+ - -  -- [ PORT $port  - OPEN ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Scanning port $porta\e[K\r"
    done
}

function udp() {
    echo "UDP protocol selected"
    echo ""
    protocol='udp'
    for port in `seq $2 $3`;
    do
    timeout 0 bash -c "</dev/$protocol/$1/$port" &>/dev/null \
    && echo -ne "+ - -  -- [ PORT $porta  - OPEN ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Scanning port $porta\e[K\r"
    done
}

options=("tcp" "udp" "sair")

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        #domain
        #port
        echo "Example of use: ./portscan-en-US.sh google.com 50 80"
elif (expr $2 + 1 > /dev/null 2>/dev/null) && (expr $3 + 1 > /dev/null 2> /dev/null); then
                echo -e "Select one of the following options\n"
        select opt in ${options[@]}
        do
        case $opt in
                "tcp")
                        tcp $1 $2 $3
                        break
                ;;
                "udp")
                        udp $1 $2 $3
                        break
                ;;  
                "sair")
                        echo "Leaving..."
                        break
                ;;
                *) echo "Invalid option"
        esac
        done
else
echo "Ports parameters only accepts whole numbers"
fi
