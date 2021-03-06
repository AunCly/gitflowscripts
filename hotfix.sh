#!/bin/bash

#############################
#  Script creation hotfix.  #
#############################

# on se place dans le bon repo
cd && cd sites/site_stimbiz

change="false"

tag=`git describe --abbrev=0 --tags`

message=`pwd`
echo "Vous êtes dans le dossier $message version $tag"

# On explode la chain de la version pour recup le numéro de tag courrant
IFS='.' read -r -a array <<< "$tag"
hotfix="${array[2]}"

# Creation du nouveau numéro de tag
let new_tag="$(($hotfix + 1))"

# on check si il y a des changement en cours
if git diff-index --quiet HEAD --; then
	echo "Pas de changements en cours"
else
	read -p 'Changements non commité stash les changements ? Y/N : ' response
	# Si oui on propose de les stash pour créer le hotfix
	if [ $response = "Y" ] ; then
		change="true"
		echo "On stash les chagements"
    	git stash
    #si non on force le fermeture du script	
    else
    	echo "Les changements doivent être stash avant la création du hotfix"
    	exit 1
	fi
fi

# creation du hotfix
echo "Création du hotfix : ${array[0]}.${array[1]}.$new_tag"
git flow hotfix start "${array[0]}.${array[1]}.$new_tag"

# on recupere les changement stash
if [ change = "true" ]; then
	git stash pop
fi

