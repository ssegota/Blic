#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i|--install)
    INSTALL="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--addusers)
    USERFILE="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo INSTALL  = "${INSTALL}"
echo USER_FILE = "${USERFILE}"



while IFS=$'\t' read -r -a myArray
do
 echo "${myArray[0]}"
 echo "${myArray[1]}"
 
 #TODO create users 
 
done < "${USERFILE}"
