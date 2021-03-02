#
#	!/usr/bin/env bash	  
#


: '
	-- + exemplos de uso + --

#Iniciando	    		#Dominio	#Portas
chmod +x portscan.sh
./portscan.sh			127.0.0.1 	1  50
source portscan.sh		127.0.0.1 	1  50
bash portscan.sh		192.168.0.1 	80 443
bash portscan.sh		192.168.0.1 	100 1500

'

#
#
#
#
#

#código

cinza="\033[30;1m"
rosa="\033[31;1m"
verde="\033[32;1m"
laranja="\033[33;1m"
branco="\033[35;1m"

#dominio() {
        if [ "$1" == "" ]; then
                echo "Parametro dominio necessario"; 
        else
                echo -ne "------------------------- $verde[$branco+$verde]$branco\033[m\n"
                echo -ne $branco"Dominio: $1\033[m\n"
        fi
#}

#porta() {
        if [[ "$2" != "" && "$3" != "" ]]; then
                echo -ne $branco"Portas: $2 ate $3\033[m\n"
                echo -ne "------------------------- $verde[$branco+$verde]$branco\033[m\n"
        else
                echo "Parametros portas necessario"
        fi
#}

function tcp() {
    echo "Protocolo TCP selecionado"
    echo ""
    protocolo='tcp'
    for porta in `seq $2 $3`;
    do
    timeout 0 bash -c "</dev/$protocolo/$1/$porta" &>/dev/null \
    && echo -ne "+ - -  -- [ PORTA $porta  - ABERTA ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Escaneando porta $porta\e[K\r"
    done
}

function udp() {
    echo "Protocolo UDP selecionado"
    echo ""
    protocolo='udp'
    for porta in `seq $2 $3`;
    do
    timeout 0 bash -c "</dev/$protocolo/$1/$porta" &>/dev/null \
    && echo -ne "+ - -  -- [ PORTA $porta  - ABERTA ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Escaneando porta $porta\e[K\r"
    done
}

opcoes=("tcp" "udp" "sair")

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        #dominio
        #porta
        echo "Exemplo de uso: ./portscan.sh google.com 50 80"
elif (expr $2 + 1 > /dev/null 2>/dev/null) && (expr $3 + 1 > /dev/null 2> /dev/null); then
                echo -e "Selecione uma opcao a seguir\n"
        select opt in ${opcoes[@]}
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
                        echo "Saindo..."
                        break
                ;;
                *) echo "Opcao invalida"
        esac
        done
else
echo "Parametros portas aceitam somente numeros inteiros"
fi
