#!/bin/bash
   
echo                                                                                              
echo "                   .___                     "
echo "_____    ____    __| _/_ __  _____    	  "
echo "\__  \  /    \  / __ |  |  \/     \z        "
echo " / __ \|   |  \/ /_/ |  |  /  Y Y  \        "
echo "(____  /___|  /\____ |____/|__|_|  /        "
echo "     \/     \/      \/           \/         "
echo "    Hunting for sensitive data - EnderPhan  "
echo
echo

if [ "$1" == "-h" ] || [ "$1" == "" ]
then
	echo "-ls                   : List installed package"
	echo "-p <packagename>      : Check if sensitive data stored in internal & external data"
	echo "-h                    : Help"
	exit 0 
fi

if [ "$1" == "-ls" ]
then
	if adb get-state 1>/dev/null 2>&1
        then
                echo
                echo "[+] Device has been found";
                echo
               	adb shell pm list packages | sed 's/package://'
		exit 0
        else
                echo "[-] No device found. Please run 'adb devices' to find your device and run 'adb connect <your-device>'";
                echo "[-] Finding devices...................";
		adb devices
		exit 0
	fi
fi
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
IFS=$'\n' read -d '' -r -a rules < creds.txt

case $key in
    -p|--packagename)
    PACKAGE="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--apk)
    APK="$2"
    shift # past argument
    shift # past value
    ;;
    -ls|--list)
    LIST=""
    shift # past argument
    shift # past value
    ;;
esac
done
set -- "${POSITIONAL[@]}"
name=${PACKAGE}
lib=${LIBRARY}
dir=${DIRECTORY}
apk=${APK}
list=${LIST}

internal_path="/data/data/"
internal_path+=$name
sdcard_path="/sdcard/Android/data/"
sdcard_path+=$name
current_path=`pwd`
tempapk="$current_path/temp/tempapk"
#sucmd=$(adb shell \"su -c 'echo'\")

searching () {
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b\r")
	
	folder=`adb shell "su -c 'find $1 -type f'"`

	for file in $folder
	do
		header=`adb shell "su -c 'strings \"$file\"'" | head -1`
		if [[ $header == "SQLite format 3" ]];
		then
			for rule in "${rules[@]}"
			do
				adb shell "su -c 'sqlite3 \"$file\" .dump | grep $rule && echo -e \"$file\" && echo '"
			done
		else
			for rule in "${rules[@]}"
			do
				adb shell "su -c 'strings \"$file\" 2>/dev/null | grep $rule && echo -e \"$file\" && echo '"
			done
		fi
	done
	IFS=$SAVEIFS
}

if [ ! -z "$name" ]
then
	if adb get-state 1>/dev/null 2>&1
 	then
		echo
 		echo "[+] Device has been found";
		echo
		#if [ "$sucmd" -eq 0 ]
		#then
		#	echo
			echo "[+] Searching for sandbox directory /data/data/"
			echo ""
			searching $internal_path
			echo "[+] Searching for external directory /sdcard/Android/data/"
			echo ""
			searching $sdcard_path
		#else
                #       	echo "[-] The device seems not to be rooted ??!! ";
		#	exit 0
		#fi
	else
 		echo "[-] No device found. Please run 'adb devices' to find your device and run 'adb connect <your-device>'";
        echo "[-] Finding devices...................";
		adb devices
		exit 0
	fi

	if [ -z $key ]
	then
		echo "[-] No path supplied, please run with '-p <package name>'"
		exit 0
	fi
else
	echo "[-] Please provide correct arguments!!!"
	exit 0
fi