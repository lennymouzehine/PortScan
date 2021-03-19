#
#	!/usr/bin/env bash	  
#


: '
	-- + EXEMPLOS DE USO + --
#Iniciando	    		#Dominio 	#Porta
chmod +x portscan.sh
./portscan.sh			127.0.0.1 	1  50
. portscan.sh                   127.0.0.1       1  100
source portscan.sh		127.0.0.1 	1  50
bash portscan.sh		192.168.0.1 	80 443
'

#
#       PortScan - Lenny Mouzehine
#

#Cores
cinza="\033[30;1m"
rosa="\033[31;1m"
verde="\033[32;1m"
laranja="\033[33;1m"
branco="\033[35;1m"

#função de ajuda
ajuda() {
        echo "Seguindo o exemplo de uso:"
        echo "./portscan-pt-BR.sh"
        echo "O script fará uma varredura no domínio e portas citadas"
        echo "É importante que o primeiro parâmetro de porta seja maior que o último parâmetro de porta citado"
        echo "Este script é recomendado para varreduras internas, pode demorar algum tempo ao tentar usá-lo em redes externas"
        echo "Digite -v ou --versao para saber informações sobre a versão atual"
        exit 0
}

#função de versão
versao() {
        echo "PortScan - Versão 1.4 (PT-BR)"
        echo "Adicionado nova interface"
        exit 1
}

#ativador de função
if test "$1" = "-a"; then
ajuda
elif test "$1" = "--ajuda"; then
ajuda
elif test "$1" = "-v"; then
versao
elif test "$1" = "--versao"; then
versao
fi

#target
read -p "Digite o domínio alvo: " dominio
read -p "Digite a porta destino inicial: " portainicial
read -p "Digite a porta destino final: " portafinal
read -p "Todas as informações estão corretas? [S/n]: " -e -n 1 op



case $op in
        (s|S)
                for carregando in `seq 2`; do
                echo -n "###"
                sleep 1
                done
                echo -e " 100%"
                sleep 0
        ;;
        (n|N)
                echo "Retornando..."
                exit 0;
        ;;
                *) echo "Opção inválida"; exit 1;;
esac

if [ "$dominio" != "" ] && [ "$portainicial" != "" ] && [ "$portafinal" != "" ]; then
        echo -ne "------------------------- $verde[$branco+$verde]$branco\033[m\n"
        echo -ne $branco"Domínio: $dominio\033[m\n"
        echo -ne $branco"Porta: $portainicial até $portafinal\033[m\n"
        echo -ne "------------------------- $verde[$branco+$verde]$branco\033[m\n"
elif [ "$dominio" == "-a" ]; then
ajuda
else
        echo -e "\nParâmetros requeridos";
        echo "Digite -a ou --ajuda para mais informações"
        exit 0
fi

function tcp() {
    dominio=$1
    portainicial=$2
    portafinal=$3
    echo "Protocolo TCP selecionado"
    echo ""
    protocolo='tcp'
    for porta in `seq $portainicial $portafinal`;
    do
    timeout 1 bash -c "</dev/$protocolo/$dominio/$porta" &>/dev/null \
    && echo -ne "+ - -  -- [ PORTA $porta  - ABERTA ] --  - - +     \n" \
    || sleep 0 ; echo -ne "Escaneando porta $porta\e[K\r"
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

opcoes=("tcp" "udp" "sair")

if [[ -z "$dominio" || -z "$portainicial" || -z "$portafinal" ]]; then
exit 0
elif (expr $portainicial + 666 > /dev/null 2>/dev/null) \
&& (expr $portafinal + 666 > /dev/null 2> /dev/null) \
&& (("$portainicial" < "$portafinal")); then
echo -e "Selecione um número entre as seguintes opções\n"
        select opc in ${opcoes[@]}
        do
        case $opc in
                "tcp")
                        tcp $dominio $portainicial $portafinal
                        break
                ;;
                "udp")
#                        udp $domain $firstport $finalport
                        echo "Indisponivel"
                        break
                ;;  
                "sair")
                        echo "Saindo..."
                        break
                ;;
                *) echo "Opção inválida"
        esac
        done
else
        echo "AVISO: OS PARÂMETROS DE PORTAS SÓ ACEITAM NÚMEROS INTEIROS"
        echo -e "AVISO: A PORTA FINAL NÃO PODE SER MENOR QUE A PORTA INICIAL\n"
        echo -e "Digite -a ou --ajuda para mais informações\n"
fi
