#!/bin/bash

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
tmp='.dzlgsttmp'

oflag=''

# Fonction affichage de l'aide rapide
function quickhelp {
	echo "Aide rapide -"
	echo "syntaxe -> ./langstat.sh [option]... nomdufichier (avec extension le cas échéant)"
	echo "Exemples: "
	echo "sans option -> ./langstat.sh dico.txt"
	echo "avec option(s) -> ./langstat.sh -v -p dico.txt"
       	echo -e "\t\tou ./langstat.sh -pvy dico.txt"
	echo "Pour plus d'informations veuillez consulter la documentation complète"
	exit 0
}

# Récupération des options et gestion des erreurs de saisie
if [ $# -lt 1 ]; then
	echo "$0 : argument(s) manquant(s)"
	exit 1
fi

while [ "$(echo "$1" | cut -c 1)" = "-" ]; do
	if [ -z `echo "$1" | cut -c 2` ]; then
		echo "erreur de syntaxe : '-' option(s) non spécifiée(s)"
		exit 1
	fi

	for option in `echo "$1" | cut -c 2- | sed 's/\(.\)/\1\n/g'`; do
		case $option in
			o)
				oflag='true'
				;;
			h)
				quickhelp
				;;
			-)
				longoption=`echo "$1" | cut -c 3-`
				case $longoption in
					help)
						quickhelp
						;;
					longoptionname)
						break	
						;;
					*)
						echo "--$longoption : option longue invalide ou non spécifiée"
						exit 1
						;;
				esac
				;;
			*)
				echo "-$option : option invalide"
				exit 1
				;;
		esac
	done
	shift
done

# Traitement du fichier passé en argument
if [ ! -e "$1" ] || [ ! -f "$1" ]; then
	echo "nom de fichier invalide ou non spécifiée"
	exit 1
fi

if [ $# -gt 1 ]; then
	echo "Les arguments placés après '$1' ont été ignorés"
fi

if [ -e $tmp ]; then
	rm $tmp
fi

if [ -z $oflag ]; then
	for char in `echo "$alphabet" | sed 's/\(.\)/\1\n/g'`; do
		echo -e "$(grep $char "$1" | wc -l)\t- $char" >> $tmp
	done
else
	sed 's/\(.\)/\1\n/g' "$1" | grep [$alphabet] | sort | uniq -c >> $tmp
fi

sort -rn $tmp
rm $tmp
