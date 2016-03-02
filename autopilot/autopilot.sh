#! /bin/bash

<<"COMMENT"
 
Auto Pilot

Script facilitador para update de sistemas de homologação e produção.
Obs: Não configurado para rodar no Cron. Este script é um facilitador de atualização dos sistemas de homologação e produção. No entanto, não é recomendável agendar a execução dele no cron visto que ele é verboso. Isto é, há interrupções, perguntas, parâmetros e caminhos que não são relativos para a execução através do cron.

COMMENT

#Verificar se o usuário está em modo root
uid=`id -un`

if [ "$uid" != "root" ]; then
	echo -e "\nPor favor, logue como root\n"

else

	#Arquivos que serão gerados a partir do index.html baixado no host por wget -q
	fileOutput=.files.html
	fileFilterNv1=filtro.txt

	# Pasta padrão onde o script irá trabalhar
	pilotPath=autopilot

	# Diretório de update, onde se armazena os arquivos baixados no host através do parse
	dirUp=update

	# Forçando o terminal a identificar o usuário que está logado 
	USER_HOME=$(eval echo ~${SUDO_USER})	

	# Endereço onde estarão os arquivos
	HostUrlFiles="url"

	# Função responsável pela execução do Scan e do Download dos arquivos *.tar.gz na data de hoje existentes no host

	function ScanDown {

	# Baixa o index.html direto do host, limpa os dados de tag's em html com sed, gera um arquivo limpo chamado files.html e remove o primeiro arquivo index.html baixado.
	wget -q $HostUrlFiles | xargs sed -e 's/<[^>]*>//g' index.html > $fileOutput && sed -i 1,2d $fileOutput && rm -f index.html
	
	# Gravar a data no formato mostrado no arquivo files.html
	dateFiles=`date +%d-%b-%Y`

	# Procurar arquivos .tar.gz com manipulação de strings na data correspondente
	searchTxtFiles="$(grep ".*.tar.gz.* $dateFiles" $fileOutput)"

	# Verifica se existe no host algum arquivo na presente data
	if [[ ! -z $(grep $dateFiles $fileOutput) ]]; then

		# Gera um filtro de texto que contém apenas os .tar.gz na cada correspondente
		for x in $searchTxtFiles
		do
			# Ler o files.html e isola apenas os dados com *.tar.gz com a data presente
			echo $x >> $fileFilterNv1 
		done

		# Isola por manipulação de strings os arquivos a serem baixados
		downloadFiles="$(grep ".*.tar.gz" $fileFilterNv1)"

		# Criando diretório caso não exista para armazenar os arquivos baixados do host
		if [[ -d "$dirUp" ]]; then
			:
		else
			echo -e "\nCriando pasta de updates\n"
			mkdir $dirUp
		fi		

		# ---------------------------------------------------------------------------------------------------
		# Trabalhando com manipulação de pastas e arquivos 
		# Procurar arquivos .tar.gz com find na pasta que estamos trabalhando

		find_stuff() { find "$1" -maxdepth 1 -mtime "$2" -type f -iname '*.tar.gz'; }

		# Modificando o parâmetro -mtime para +0 do find_stuff
		verifyOldFiles=$(find_stuff $dirUp +0)

		for x in $verifyOldFiles
		do
			# Se existirem arquivos em $dirUp anteriores à data do sistema, se cria um diretório chamado backups onde serão movidos.
			# Aqui é onde o SPO irá trabalhar para organizar as coisas
			if [[ -f $x ]]; then
				mkdir -p $dirUp/backups/
				# O diretório backups estará em /autopilot/backups
				$x | xargs mv backups/
			fi
		done

		# Se no entanto o diretório $dirUp estiver vazio, efetua o Download dos arquivos atualizados do host
		if find $dirUp -maxdepth 0 -empty | read v; then
			for d in $downloadFiles
			do
				echo -e "\nBaixando arquivos do $HostUrlFiles atualizados no dia $dateFiles\n"
				echo -e "$(wget -c -N -P $dirUp $HostUrlFiles$d)"
			done

		fi

		verifyNewFiles=$(find_stuff $dirUp 0)

		# Verificando se já existem arquivos atualizados na pasta 
		for i in $verifyNewFiles
		do
			if [[ -f $i ]]; then
				echo -e "\nDescompactando $dateFiles em $dirUp\n"
				cd $dirUp && ls *.tar.gz | xargs tar -vzxf
			fi
		done		

	else
		# Caso não existam arquivos atualizados no host
		echo -e "\nNão existem arquivos no $HostUrlFiles atualizados em $dateFiles!\n"

	fi

	# ---------------------------------------------------------------------------------------------------

	} 

# Pemitir que o script seja chamado por fora
#$@
ScanDown
	
	# Verificando se a pasta autopilot já existe ou não no sistema
	if [[ -d "/home/${SUDO_USER}/$pilotPath/" ]]; then
		# Se a pasta autopilot/ já existe, ignora.
		:
	else
		# Se não existe a pasta, cria o diretório, entra e executa o script
		echo -e "\nCriando o diretório $pilotPath em /home/${SUDO_USER}/\n"
		mkdir -p /home/${SUDO_USER}/$pilotPath/ 
	fi



# fim do script
fi


