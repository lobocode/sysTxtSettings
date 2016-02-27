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
	#files="*.tar.gz"

	fileOutput=files.html

	fileFilterNv1=filtro.txt

	# Endereço onde estarão os arquivos
	#HostUrlFiles="http://www.car.ti.lemaf.ufla.br/bkp/releases_prod/"

	# Procurar arquivos .tar.gz atuais
	#searchFiles="$(find . -maxdepth 1 -mtime +0 -type f -iname \$files)"

	# Fazendo análise de arquivos no host e gerando um file.html com os respectivos dados do index 
	# sem o código html
	#wget -q $HostUrlFiles | xargs sed -e 's/<[^>]*>//g' index.html > $fileOutput && sed -i 1,2d $fileOutput
	
	#Removendo lixo
	#rm index.html
	
	#Data recente
	dataFiles=`date +%d-%b-%Y`

	# Procurar arquivos .tar.gz com manipulação de strings na data correspondente
	searchTxtFiles="$(grep ".*.tar.gz.* $dataFiles" $fileOutput)"

	# Gera um filtro de texto que contém apenas os .tar.gz na cada correspondente
	for x in $searchTxtFiles
	do
		echo $x >> $fileFilterNv1 
	
	done	

	# Isola por manipulação de strings os arquivos a serem baixados
	downloadFiles="$(grep ".*.tar.gz" $fileFilterNv1)"

	for i in $downloadFiles 
	do
		echo "$(wget -c $i)" && rm -f $fileFilterNv1
	done

	


	# Encontrar nome do arquivo padrão + data do dia concatenar dados e usar como base para download

fi


