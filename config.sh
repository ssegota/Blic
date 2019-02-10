#!/bin/bash

# varijable korištene u skripti
# polja sa nazivima programa za preuzimanje
DEV=( "vim" "build-essential" "python3" "spyder3")
EMU=( "qemu" "openssh-server" )
MED=( "vlc" "cmus" )
WMD=( "i3" "terminator" )

#Prefix za preuzimanje
# -y opcija da izbjegnemo interaktivnost
DOWNSTRING="apt install -y "

#ČITANJE ARGUMENATA
#dok ima zadanih argumenata...
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

# Čitanje argumenata
# Ako je key varijabla jednaka zadannom argumentu (arg. broj 1) (npr. -i) tada postavi 
# odgovarajuću varijablu (npr. INSTALL) na vrijednost drugog argumenta
# Zatim se pomakni za 2 argumenta koristeći shift, kako bismo sljedećim argumentima mogli
#pristupati kao prvom i drugom, bez obzira na to koliko ih ima
case $key in
    -i|--install)
    INSTALL="$2"
    shift 
    shift 
    ;;
    -u|--addusers)
    USERFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--configfiles)
    CONFIG_FILES="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    #ispisi pomoc
    echo -e "Options are:"
    echo -e "\t [-i|--install] install programs, use d, e, m or w - or any combination to pick a group"
    echo -e "\t usage: sudo bash config.sh -i demw"
    echo -e "\t\t m - media playback"
    echo -e "\t\t d - development tools"
    echo -e "\t\t e - emulation tools"
    echo -e "\t\t w - window manager download"
    echo -e "\t [-c|--config] download and copy config from git repo or server"
    echo -e "\t usage: sudo bash config.sh -c https://github.com/ssegota/config-files"
    echo -e "\t [-u|--addusers] addusers from a file"
    echo -e "\t usage: sudo bash config.sh -u users.txt"
    shift
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    echo "unkown option $1, use --help if unsure of usage" 
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#ISPIS ZADANIH ARGUMENATA
echo INSTALL  = "${INSTALL}"
echo USER_FILE = "${USERFILE}"
echo CONFIG_FILES = "${CONFIG_FILES}"

#INSTALACIJA PROGRAMA
#ZA svaki od zadanih grupa za download (npr. dem)
for (( i=0; i<${#INSTALL}; i++ )); do
  #preuzmi sljedeće slovo
  DOWNLOADTYPE="${INSTALL:$i:1}"
  #ako slovo odgovara nekom od postojećih grupa
  if [ "$DOWNLOADTYPE" = "d" ] || [ "$DOWNLOADTYPE" = "D" ] 
  then
    #za svaki element u odgovarajućem polju
    for j in "${DEV[@]}"
    do
        #spoji download prefix(apt install) sa nazivom programa iz polja
        tmp="$DOWNSTRING$j"
        #izvrši kreiranu naredbu korištenjem eval funkcije
	    eval "$tmp"
    done
  elif [ "$DOWNLOADTYPE" = "e" ] || [ "$DOWNLOADTYPE" = "E" ] 
  then
    for j in "${EMU[@]}"
    do
        tmp="$DOWNSTRING$j"
	    eval "$tmp"
    done
  elif [ "$DOWNLOADTYPE" = "m" ] || [ "$DOWNLOADTYPE" = "M" ] 
  then
    for j in "${MED[@]}"
    do
        tmp="$DOWNSTRING$j"
	    eval "$tmp"
    done
  elif [ "$DOWNLOADTYPE" = "w" ] || [ "$DOWNLOADTYPE" = "W" ] 
  then
    for j in "${WMD[@]}"
    do
        tmp="$DOWNSTRING$j"
	    eval "$tmp"
    done
  else 
    echo "Invalid option, use d, e, m or w - or any combination of those (eg. dem)"
  fi
done

#Ako je zadana opcija -c
if [ -n "$CONFIG_FILES" ]; then
    #Ako je string git repozitorij (sadržava "git")
    if [[ $CONFIG_FILES =~ .*git.* ]]
        then
        #kloniraj repozitorij u privremeni direktorij
        eval git clone $CONFIG_FILES ./tmp_config
    #Ako nije (npr. preuzimanje sa servera)
    else 
        #preuzmi sa wget u privremeni direktorij
        eval wget --directory-prefix ./tmp_config $CONFIG_FILES
    fi
    #postavi privremeni direktorij kao radni
    cd tmp_config
    #kopiraj .bashrc u home direktorij
    cp -rf .bashrc ~
    rm .bashrc
    #Ostale datoteke kopiraj u .config direktorij
    \cp -rf * ~/.config/
    #vrati se u direktorij pokretanja
    cd ..
    #obriši privremeni direktorij
    rm -rf ./tmp_config
fi

### POSTAVLJANJE KORISNIKA
# U ovom dijelu skripte se dodaju movi korisnici iz zadane datoteke

#AKO je zadana opcija -u
if [ -n "$USERFILE" ]; then
    #Učitaj delimitiranu datoteku i dok u njoj ima teksta
    while IFS=$'\t' read -r -a userArray
    do
    #Učitaj korinsičko ime
    USERNAME="${userArray[0]}"
    #Učitaj Password
    PASSWORD="${userArray[1]}"
    
    #Stvori korisnika 
    adduser "$USERNAME" --gecos "" --disabled-password
    #Dodaj mu lozinku
    echo "$USERNAME:$PASSWORD" | chpasswd
    
    #Zatvori datoteku
    done < "${USERFILE}"
fi
