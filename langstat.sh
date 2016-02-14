#!/bin/bash

alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
tmp='.dzlgsttmp'

if [ $# -lt 1 ]; then
	echo "argument(s) manquant(s)"
	exit 1
fi

# Récupération des options
while [ "`echo "$1" | cut -c 1`" = "-" ]; do
	
	if [ -z `echo "$1" | cut -c 2` ]; then
		echo "syntaxe : '-' option(s) non spécifiée(s)"
		exit 1
	fi

	for option in `echo "$1" | cut -c 2- | sed -E s'/(.)/\1\n/g'`; do
		case $option in
			*)
				echo "-$option : option non valide"
				;;
		esac
	done
	shift
done

# Traitement du fichier
if [ -e "$1" ]; then
	
	if [ $# -gt 1 ]; then
		echo "Les arguments placés après '$1' ont été ignorés"
	fi

	if [ -e $tmp ]; then
		rm $tmp
	fi
	for char in `echo "$alphabet" | sed -E s'/(.)/\1\n/g'`; do
		echo -e "$(grep $char "$1" | wc -l)\t- $char" >> $tmp
	done
	sort -rn $tmp
	rm $tmp
else
	echo "nom de fichier invalide ou manquant"
fi
