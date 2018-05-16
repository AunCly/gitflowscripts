#!/bin/bash

# définition des variables
#change=false

# on se place dans le bon repo
cd && cd sites/site_stimbiz

tag=`git describe`

message=`pwd`
echo "Vous êtes dans le dossier $message version $tag"


# On explode la chain de la version pour recup le numéro de tag courrant
IFS='.' read -r -a array <<< "$tag"
hotfix="${array[2]}"

# Creation du nouveau numéro de tag
let new_tag="$(($hotfix + 1))"

echo "new tag $new_tag"

# on check si il y a des changement en cours
if git diff-index --quiet HEAD --; then
	read -p "Changements non commité stash les changements ? : Y/N" response
	# Si oui on propose de les stash pour créer le hotfix
	if $response="Y" ; then
		change=true
    	git stash
    #si non on force le fermeture du script	
    else
    	exit 1
	fi
fi

# creation du hotfix
git flow hotfix start "${array[0]}.${array[1]}.$tag"

# on recupere les changement stash
if [[ change ]]; then
	git stash pop
fi

