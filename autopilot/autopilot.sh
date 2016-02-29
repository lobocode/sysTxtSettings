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

	#Arquivos que serão gerados a partir do index.html baixado no host por wget -q
	fileOutput=files.html
	fileFilterNv1=filtro.txt

	# Pasta padrão onde o script irá trabalhar
	pilotPath=autopilot/

	# Forçando o terminal a identificar o usuário que está logado 
	USER_HOME=$(eval echo ~${SUDO_USER})	

	# Verificando se a pasta autopilot já existe ou não no sistema
	if [[ -d "$pilotPath" ]]: then

		# Se a pasta autopilot/ já existe, entra e executa o script
		cd /home/${SUDO_USER}/$pilotPath/ && ScanDown
	else
		# Se não existe a pasta, cria o diretório, entra e executa o script
		mkdir -p /home/${SUDO_USER}/$pilotPath && cd /home/${SUDO_USER}/$pilotPath && ScanDown
	fi


	# Função responsável pela execução do Scan e do Download dos arquivos *.tar.gz na data de hoje existentes no host

	function ScanDown {

	# Endereço onde estarão os arquivos
	HostUrlFiles="http://www.car.ti.lemaf.ufla.br/bkp/releases_prod/"

	# Baixa o index.html direto do host, limpa os dados de tag's em html com sed, gera um arquivo limpo chamado files.html e remove o primeiro arquivo index.html baixado.
	wget -q $HostUrlFiles | xargs sed -e 's/<[^>]*>//g' index.html > $fileOutput && sed -i 1,2d $fileOutput && rm -f index.html
	
	# Gravar a data no formato mostrado no arquivo files.html
	dataFiles=`date +%d-%b-%Y`

	# Procurar arquivos .tar.gz com manipulação de strings na data correspondente
	searchTxtFiles="$(grep ".*.tar.gz.* $dataFiles" $fileOutput)"

	# Gera um filtro de texto que contém apenas os .tar.gz na cada correspondente
	for x in $searchTxtFiles
	do
		# Ler o files.html e isola apenas os dados com *.tar.gz com a data presente
		echo $x >> $fileFilterNv1 
	
	done	


	# Isola por manipulação de strings os arquivos a serem baixados
	downloadFiles="$(grep ".*.tar.gz" $fileFilterNv1)"

	# Procurar arquivos .tar.gz com find na pasta que estamos trabalhando
	verifyFiles="$(find . -maxdepth 1 -mtime +0 -type f -iname '*.tar.gz')"

	for i in $verifyFiles
	do
		if [[ -f $i ]]; then
			# Se existem arquivos *.tar.gz na pasta
			echo -e "\nJá existem arquivos referentes à data $dataFiles nesta pasta\n"
		else
			# Se não existem
			for x in $downloadFiles
			do
				# Baixar arquivos *.tar.gz direto do host e remover filtro
				echo -e "$(\nwget -c $x em $dataFiles\n)" && rm -f $fileFilterNv1
		fi
	done

	}

	













# fim do script
fi


