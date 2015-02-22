#!/bin/bash

function buildParams 
{
	nd="/opt/websphere/85/appserver/profiles/DM_*"
	base="/opt/websphere/85/appserver/profiles/AA_*"

	echo "[--] Dostepne cele do instalacji: "
	ls -ltr /opt/websphere/85/appserver/profiles/ | awk '{print $9}'
	count=`ls -l ${nd} 2>/dev/null | wc -l`
	
	if [[ $count != 0 ]]; then
		echo "DMGR - WAS 8.5 ND"
		echo "[+] Podaj dane kofniguracyjne"
		echo "-> Wpisz nazwe celi"
		read cell
		echo "-> Wpisz nazwe node'a"
		read node
		echo "-> Wpisz nazwe servera"
		read server

		echo "cellName =" $cell >> ${server}_${node}.properties
		echo "nodeName =" $node >> ${server}_${node}.properties
		echo "serverName =" $server"_Server" >> ${server}_${node}.properties
		echo "clusterName =" $server"_Cluster" >> ${server}_${node}.properties
	else
		count=`ls -l ${base} 2>/dev/null | wc -l`
		if [[ $count != 0 ]]; then
			echo "AdminAgent - WAS 8.5 Base"
			node=$(hostname)
			echo "[+] Podaj dane kofniguracyjne"
			echo "-> Wpisz nazwe celi"
			read cell
			#echo "-> Wpisz nazwe node'a"
			#read node
			echo "-> Wpisz nazwe servera"
			read server

			echo "cellName =" $cell >> ${server}_${node}.properties
			echo "nodeName =" hostname >> ${server}_${node}.properties
			echo "serverName =" $server"_Server" >> ${server}_${node}.properties
		else
			echo "[!!!] Brak WASa na hoscie. Opuszczam procedure."
			exit
		fi
	fi

	echo "
#custom properties
com.ibm = true
db = true
secman = false
#jvm 
initialHeap = 128
maximumHeap = 512" >> ${server}_${node}.properties
	echo "[+] Plik konfiguracyjny zostal przygotowany."
}

function createJVM
{
	echo "[--] Rozpoczynam tworzenie serwera aplikacyjnego"
	file=./${server}_${node}.properties
	if [ -e "$file" ]; then
	    echo "Plik konfiguracji istnieje."
	else 
	    echo "Brak pliku konfiguracyjnego. Sprawdz plik konfiguracyjny."
	    exit
	fi 
}

echo "# Skrypt tworzacy nowa instancje serwera aplikacyjnego WAS 8.5"
buildParams
createJVM
