#!/bin/bash

# Rss url
url="http://gitlab.ti.lemaf.ufla.br/car/sicar/commits/master.atom?private_token=yyR9J3j39ryz_eBfkRqx"

# Endereço online
urlOnline="http://gitlab.ti.lemaf.ufla.br/car/sicar/commits/master.atom?private_token=yyR9J3j39ryz_eBfkRqx"


hookUrl="http://rocket.ti.lemaf.ufla.br/hooks/D4J8xpSBgSJGqwQC8/LPcbTzM2qmKauKSPrHvBHPGTHbNL24n9PedTJ9GGmtsKMQYq"

# Último titulo do commit
title="$(curl --silent "$url" | grep -E '(title)' | sed -n 2p | sed -e 's/<title>//' -e 's/<\/title>//')"

# Data do commit
commitData="$(curl --silent "$url" | grep -E '(updated)' | sed -n 2p | sed -e 's/<updated>//' -e 's/<\/updated>//')"

# Autor do commit
author="$(curl --silent "$url" | grep -E '(name)' | sed -n 2p | sed -e 's/<name>//' -e 's/<\/name>//')"

# Link do commit master
commitLink="$(curl --silent "$url" | grep -E '(id)' | sed -n 2p | sed -e 's/<id>//' -e 's/<\/id>//')"


final="$(echo -e "Commit de $author, de nome $title, link $commitLink - as $commitData")"


# while true:
# do
	# sleep 50
	#curl -X POST --data-urlencode 'payload={"icon_emoji":":ghost:","text":"gitlab:","attachments":[{"text":"'"$final"'","color":"#764FA5"}]}' $hookUrl

# done

if [[ curl -L $urlOnline == $rssFile ]]; then
	#statements
	echo -e "Rss não alterado\n"
else
	curl -X POST --data-urlencode 'payload={"icon_emoji":":ghost:","text":"gitlab:","attachments":[{"text":"'"$final"'","color":"#764FA5"}]}' $hookUrl
fi

# curl -X POST --data-urlencode 'payload={"icon_emoji":":ghost:","text":"gitlab:","attachments":[{"text":"'"$final"'","color":"#764FA5"}]}' $hookUrl


