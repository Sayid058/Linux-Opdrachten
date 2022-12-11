#! /bin/bash

###
# script om bestanden te verplaatsen, te sorteren en automatisch te verwijderen
# studenten: Davy van Weijen, Sayid Abd-Elaziz
###

echo "Script wordt gestart"

dir=$1 # directory als parameter van het script
var=$2 # maand of week

if [ -d "$dir" ]; # als dir een directory is, ga verder met de code
then	
	# ga door de directory $dir heen
	for i in "$dir"/*
	do
		if [ -f "$i" ]; # als item een bestand is (-f) ...
		then
			if [ $var == "week" ]; # als er geordend moet worden op week
			then
				fullDir="$dir$creationweek" # directory naam
				creationweek=$(ls -l --time-style='+%-V' "$i" | awk '{print $6}')
				if [ -d "$dir$creationweek" ]; 
				then # als de directory naam al bestaat hoeft deze niet aangemaakt te worden
					cp $i "$dir$creationweek/"
				else # als de directory naam nog niet bestaat moet deze wel aangemaakt worden
					mkdir "$dir$creationweek/"
					cp $i "$dir$creationweek/"
				fi
				
				originalhash=$(sudo md5sum "$i" | cut -d " " -f1) # hash van het originele bestand
				newhash=$(sudo md5sum "$dir$creationweek/${i##*/}" | cut -d " " -f1) # hash van het nieuwe bestand
				if [ $originalhash == $newhash ];
				then # als deze hashes gelijk zijn kan het origineel verwijdert worden
					rm $i
				fi

				echo "Bestand $i is gemaakt in week: $creationweek en gekopieerd naar $dir/$creationweek/" # laat zien waar het bestand heen is verplaatst
			else
				creationmonth=$(ls -l --time-style='+%-m' "$i" | awk '{print $6}')
				if [ -d "$dir$creationmonth" ];
				then # als de directory naam al bestaat hoeft deze niet aangemaakt te worden
					cp $i "$dir$creationmonth/"
				else # als de directory naam nog niet bestaat moet deze wel aangemaakt worden
					mkdir "$dir$creationmonth/"
					cp $i "$dir$creationmonth/"
				fi
				
				originalhash=$(sudo md5sum "$i" | cut -d " " -f1) # hash van het originele bestand
				newhash=$(sudo md5sum "$dir$creationmonth/${i##*/}" | cut -d " " -f1) # hash van het nieuwe bestand
				if [ $originalhash == $newhash ];
				then # als deze hashes gelijk zijn kan het origineel verwijdert worden
					rm $i 
				fi
				echo "Bestand $i is gemaakt in maand: $creationmonth en gekopieerd naar $dir/$creationmonth/" # laat zien waar het bestand heen is verplaatst
			fi
		fi
	done
else
	echo "Geen directory ingevoerd, code stopt"
	exit		
fi