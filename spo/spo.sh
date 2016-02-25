#! /bin/bash

<<"COMMENT"
 
SPO - System Paths Organizer

 Script de padronização de caminhos de pastas e arquivos. Tudo o que for pasta de backup de sistemas, e arquivos de extensão *.tar.gz de releases de atualização, será criado uma pasta backup/ e releases/. O script verifica a data atual e organiza as pastas de backups e releases de acordo com a data anterior ao dia atual (sem comprometer o trabalho), e gerando log em /var/log/orgfolders/orgfolders.log

COMMENT

#Verificar se o usuário está em modo root
uid=`id -un`

if [ "$uid" != "root" ]; then
	echo -e "\nPor favor, logue como root\n"

else

	
	#Nome do serviço
	serviceCar=sicar
	
	#Pasta do serviço
	servicePath=/var/play
	
	#Data do dia
	datePath=`date +%b-%d-%m-%y`
	
	#Entrando na pasta 
	cd $servicePath

	# Organizar as pastas 
	function orgFolders {
		
		#Verifica se o diretório de backups já existe na pasta /var/play/sicar
		if [[ -d "backups/" ]]; then
		
			# Se o diretório backups/ já existe, uma busca é feita a procura de pastas de backup anteriores a data do dia para serem movidas para a pasta backups/
			# mv -t de target, -v de verbose
			echo -e "\nOrganizando pastas de backup\n"
			verify="$(find $serviceCar-bkp-* -mtime +0)" 
			
			# Definindo a variável a cima
			set -- $verify
			

			for x in $verify
			do
				# Verificar se existem pastas anteriores à data presente de bkp no local			
				if [[ -d $x ]]; then
					# Se sim, move para a pasta backups
					echo -e "\nMovendo os arquivos de backup do $serviceCar em $datePath para backups/\n"	
					echo $(find $serviceCar-bkp-* -mtime +0 | xargs mv -v -t backups/)
					echo ""
				fi
			done
			
			# Se a verify retornar um valor vazio ou nulo
			if [[ -z $verify ]]; then
				echo -e "\nNão existem pastas para backup no diretório $serviceCar em $datePath\n"
			fi

		else
			echo -e "\nCria diretorio\n"
			# Se não, cria o diretório e executa o mesmo comando a cima
			mkdir backups 

			# E se existirem pastas de para backup, efetua a tarefa
			for x in $verify
			do
				# Verificar se existem pastas anteriores à data presente de bkp no local			
				if [[ -d $x ]]; then
					# Se sim, move para a pasta backups
					echo -e "\nMovendo os arquivos de backup do $serviceCar em $datePath para backups/\n"	
					echo $(find $serviceCar-bkp-* -mtime +0 | xargs mv -v -t backups/)
					echo ""
				fi
			done
			
			# Atribuindo o proprietário da pasta para root:root recursivamente. Isto é, coloca a disposição do usuário root todos backups contidos na pasta
			chown -R root:root backups/ 
		fi
			

		# O mesmo processo para arquivos releases com algumas configurações diferentes:
		
		#Verifica se o diretório de backup já existe na pasta
		if [[ -d "releases/" ]]; then
		
			# Se o diretório releases/ já existe, uma busca é feita a procura de arquivos que comecem com release* com a extensão .tar.gz anteriores a data do dia, e são movidos para a pasta releases/
			# mv -t de target, -v de verbose
			echo -e "\nOrganizando arquivos release\n"
			verifyRel="$(find *.tar.gz -mtime +0 -type f )"


			# definindo a variável a cima
			set -- $verifyRel

			for i in $verifyRel
			do
				# Se existem arquivos *.tar.gz na pasta /var/play
				if [[ -f $i ]]; then
					# Se existe
					echo -e "\nMovendo os arquivos de release do $serviceCar em $datePath para releases/\n"
					echo $(find *.tar.gz -mtime +0 -type f | xargs mv -v -t releases/)
					echo ""
				fi
			done

			# Se a verify retornar um valor vazio ou nulo
			if [[ -z $verifyRel ]]; then
				echo -e "\nNão existem arquivos de release para backup no diretório $serviceCar em $datePath\n"
			fi
			
		else
			# Se não existe a pasta releases/, o script scria o diretório no local
			mkdir releases 

			# E se existirem arquivos .tar.gz para backup, efetua a tarefa
			for i in $verifyRel
			do
				if [[ -d $i ]]; then
					# Se existe
					echo -e "\nMovendo os arquivos de release do $serviceCar em $datePath para releases/\n"
					echo $(find *.tar.gz -mtime +0 -type f | xargs mv -v -t releases/)
					echo ""
				fi
			done
			
			# Atribuindo o proprietário da pasta para root:root recursivamente. Isto é, coloca a disposição do usuário root todos os releases contidos na pasta
			chown -R root:root releases/ 
			
		
		fi			
		
	} >> /var/log/orgfolders/orgfolders.log

	 # Gerar logs
	function orgFoldersLog {

		if [[ ! -d "/var/log/orgfolders/" ]]; then

			# Se já existe a pasta no sistema de logs
			# Entra na pasta e grava o log
			mkdir -p /var/log/orgfolders/ 
		fi
	}
	
	

# Chamando as funções criadas
orgFolders
orgFoldersLog
	
fi
	
	
