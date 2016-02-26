#! /bin/bash

<<"COMMENT"
 
Auto Pilot

Script facilitador para update de sistemas de homologação e produção.

COMMENT

#Verificar se o usuário está em modo root
uid=`id -un`

if [ "$uid" != "root" ]; then
	echo -e "\nPor favor, logue como root\n"

else

	#Arquivos do host
	files="*.tar.gz"

	# Endereço onde estarão os arquivos
	HostUrlFiles="car.ti.lemaf.ufla.br/"

	# Procurar arquivos .tar.gz atuais
	searchFiles="$(find . -maxdepth 1 -mtime +0 -type f -iname \$files)"

	if [ -f ]