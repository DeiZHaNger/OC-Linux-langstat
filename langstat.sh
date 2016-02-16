#!/bin/bash

# Fonction affichage de l'aide rapide
function quickhelp {
	echo "Aide rapide -"
	echo "syntaxe -> ./langstat.sh [option]... nomdufichier (avec extension le cas échéant)"
	echo "Exemples: "
	echo "sans option -> ./langstat.sh dico.txt"
	echo "avec option(s) -> ./langstat.sh -i -o dico.txt"
       	echo -e "\t\tou ./langstat.sh -ioy dico.txt"
	echo "Quelques options valides: -i | -l | -o | -t | -y"
	echo "Pour plus d'informations veuillez consulter la documentation complète"
	exit
}

# Fonction affichage et sortie en cas d'erreur
function errorcase {
	echo "Utilisez l'option -h ou --help pour vérifier la syntaxe"
	exit
}

# Récupération des options et gestion des erreurs de saisie
if [ $# -lt 1 ]; then
	echo "$0 : argument(s) manquant(s)"
	errorcase
fi

while [ "$(echo "$1" | cut -c 1)" = "-" ]; do
	if [ -z `echo "$1" | cut -c 2` ]; then
		echo "erreur de syntaxe : '-' option(s) non spécifiée(s)"
		errorcase
	fi

	for option in `echo "$1" | cut -c 2- | sed 's/\(.\)/\1\n/g'`; do
		case $option in
			h)
				quickhelp
				;;
			i)
				igrep='-i'
				;;
			l)
				lflag='true'
				;;
			L)
				Lflag='true'
				;;
			o)
				oflag='true'
				;;
			t)
				tflag='true'
				;;
			y)
				hyphen='-'
				;;
			-)
				longoption=`echo "$1" | cut -c 3-`
				case $longoption in
					help)
						quickhelp
						;;
					lower-only)
						Lflag='true'
						break
						;;
					plus-lower)
						pluslower='àâäçèéêëîïôöùûüæœ'
						break
						;;
					plus-upper)
						plusupper='ÀÂÄÇÈÉÊËÎÏÔÖÙÛÜÆŒ'
						break
						;;
					plus-spec)
						plusspec="?!',;:"
						break
						;;
					*)
						echo "--$longoption : option longue invalide ou non spécifiée"
						errorcase
						;;
				esac
				;;
			*)
				echo "-$option : option invalide"
				errorcase
				;;
		esac
	done
	shift
done

#Préparation de la liste de caractères à analyser
uppercase='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
lowercase='abcdefghijklmnopqrstuvwxyz'
alphabet=$uppercase

if [ ! -z $iflag ]; then
	lflag=''
	Lflag=''
fi

if [ ! -z $lflag ]; then
	alphabet=$alphabet$lowercase
fi

if [ ! -z $Lflag ]; then
	alphabet=$lowercase
fi

alphabet=$alphabet$hyphen$pluslower$plusupper$plusspec

# Traitement du fichier passé en argument
if [ ! -e "$1" ] || [ ! -f "$1" ]; then
	echo "nom de fichier invalide ou non spécifiée"
	errorcase
fi

if [ $# -gt 1 ]; then
	echo "Les arguments placés après '$1' ont été ignorés"
fi

outtmp='.dzlgstouttmp'
if [ -e $outtmp ]; then
	rm $outtmp
fi

intmp='.dzlgstintmp'
if [ -e $intmp ]; then
	rm $intmp
fi

if [ -z $oflag ]; then
	if [ -z $tflag ]; then
		cp "$1" $intmp
	else
		sed "s/'/' /g" "$1" | sed 's/-/- /g' | sed 's/ /\n/g' > $intmp
	fi
else
	sed 's/\(.\)/\1\n/g' "$1" > $intmp
fi

for char in `echo "$alphabet" | sed 's/\(.\)/\1\n/g'`; do
	echo "$(grep $igrep $char $intmp | wc -l)-$char" >> $outtmp
done

sort -rn $outtmp | sed 's/\([0-9]*\)-\(.\)/\2 = \1/g'
rm $outtmp
rm $intmp
