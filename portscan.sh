#
#	!/usr/bin/env bash	  
#


: '
	-- + USAGE EXAMPLES + --
#Starting	    		#Domain 	#Port
chmod +x portscan.sh
./portscan.sh			127.0.0.1 	1  50
. portscan.sh                   127.0.0.1       1  100
source portscan.sh		127.0.0.1 	1  50
bash portscan.sh		192.168.0.1 	80 443
'

#
#       PortScan - Lenny Mouzehine
#

#colors
grey="\033[30;1m"
pink="\033[31;1m"
green="\033[32;1m"
orange="\033[33;1m"
white="\033[35;1m"

#function help
helper() {
        echo "Following the usage example:"
        echo "./portscan.sh"
        echo "The script will scan the cited domain and ports"
        echo "It's important that the first port parameter is less than the last port parameter"
        echo "This script is recommended for internal scans, it may take time to scan an entire external networking"
        echo "Type -v or --version for version information"
        exit 0
}

#function version
version() {
        echo "PortScan - Version 1.4"
        echo "Updated new interface"
        exit 1
}

#function activator
if test "$1" = "-h"; then
helper
elif test "$1" = "--help"; then
helper
elif test "$1" = "-v"; then
version
elif test "$1" = "--version"; then
version
fi

#target
read -p "Type the target domain: " domain
read -p "Type the starting destination port: " firstport
read -p "Type the final destination port: " finalport
read -p "Is all the information correct? [Y/n]: " -e -n 1 op

case $op in
        (y|Y)
                for loading in `seq 2`; do
                echo -n "###"
                sleep 1
                done
                echo -e " 100%"
                sleep 0
        ;;
        (n|N)
                echo "Returning..."
                exit 0;
        ;;
                *) echo "Invalid option"; exit 1;;
esac

if [ "$domain" != "" ] && [ "$firstport" != "" ] && [ "$finalport" != "" ]; then
        echo -ne "------------------------- $green[$white+$green]$white\033[m\n"
        echo -ne $white"Domain: $domain\033[m\n"
        echo -ne $white"Port: $firstport to $finalport\033[m\n"
        echo -ne "------------------------- $green[$white+$green]$white\033[m\n"
elif [ "$domain" == "-h" ]; then
helper
else
        echo -e "\nRequired parameters";
        echo "Type -h or --help for more informations"
        exit 0
fi

function tcp() {
    domain=$1
    firstport=$2
    finalport=$3
    echo "TCP protocol selected"
    echo ""
    protocol='tcp'
    for port in `seq $firstport $finalport`;
    do
    timeout 1 bash -c "</dev/$protocol/$domain/$port" &>/dev/null \
    && echo -ne "+ - -  -- [ PORT $port  - OPEN ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Scanning port $port\e[K\r"
    done
}

#function udp() {
#    domain=$1
#    firstport=$2 
#    finalport=$3 
#    echo "UDP protocol selected"
#    echo ""
#    protocol='udp'
#    for port in `seq $firstport $finalport`;
#    do
#    timeout 1 bash -c "</dev/$protocol/$domain/$port" &>/dev/null \
#    && echo -ne "+ - -  -- [ PORT $port  - OPEN ] --  - - +     \n" \
#    || sleep 0 ; echo -ne "Scanning port $port\e[K\r"
#    done
#}

options=("tcp" "udp" "quit")

if [[ -z "$domain" || -z "$firstport" || -z "$finalport" ]]; then
exit 0
elif (expr $firstport + 666 > /dev/null 2>/dev/null) \
&& (expr $finalport + 666 > /dev/null 2> /dev/null) \
&& (("$firstport" < "$finalport")); then
echo -e "Select a number from the following options\n"
        select opt in ${options[@]}
        do
        case $opt in
                "tcp")
                        tcp $domain $firstport $finalport
                        break
                ;;
                "udp")
#                        udp $domain $firstport $finalport
                        echo "Unavailable"
                        break
                ;;  
                "quit")
                        echo "Leaving..."
                        break
                ;;
                *) echo "Invalid option"
        esac
        done
else
        echo "WARNING: ports parameters only accepts whole numbers"
        echo -e "WARNING: the end port cannot be less than the start port\n"
        echo -e "Type -h or --help for more informations\n"
fi
