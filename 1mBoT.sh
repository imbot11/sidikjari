#!/data/data/com.termux/files/usr/bin/bash

# Author:  1mBoT 

## ! If you stuck on "Authentication Required". Check:

## 1. Both termux and termux-api are downloaded from playstore.
## (Both apps are free. Do not download from other sites 
## like apkmirror.com) or if you have f-droid then download 
## from there. But remember download both from same source.

## 2. Check your internet connection.
## try to run following command manually &  run setup again.
## apt-get update && apt-get upgrade
## apt-get install termux-api

## 3. If still not working then it could be your device issue.
## check your android version is 6.0+.


#colors and other variables.
R='\033[1;31m'
C='\033[0;36m'
B='\033[1;34m'
G='\033[1;32m'
Y='\033[1;33m'
U='\033[3A'
N='\033[0m'
FILE=$(which login)

trap 'echo -en "$N"' 0 1 15 20

#Banner
clear
echo
echo -e $B" ┌─────────────────────────┐ "
echo -e $B" │$C Sidik Jari 1mBoT $B│"
echo -e $B" └─────────────────────────┘ "
echo -e $R"  -> 1mBoT "
echo
echo


#Check if lock already exists.
grep -q "termux-fingerprint" $FILE; 

#if true then remove lock
if [ $? -eq 0 ]; then
    echo -e $Y" [*] Removing Lock......................\r"
    echo
    sleep 1
    echo -e $G" [!] Authentication Required\r $U"
    sleep 1

    #Authenticate fingerprint
    termux-fingerprint | grep -q "AUTH_RESULT_SUCCESS"

    #if success delete lock
    if [ $? -eq 0 ]; then
        sed -i '/termux-fingerprint/d' $FILE
        rm -f $0
        sleep 2
        echo -e $Y" [!] Removing Lock......................$G DONE"
        echo
        echo "                                   "

    #else exit
    else
        echo -e $Y" [!] Removing Lock......................$R ERR"
        echo
        echo -e $R" [!] Exiting...                               "
        exit 1
    fi 

#if lock do not exist. set one
else
    echo -ne $Y" [*] Installing Dependencies............\r"
    apt-get update &> /dev/null && apt-get upgrade -y &> /dev/null
    apt-get install termux-api -y &> /dev/null
    sleep 2
    echo -e $Y" [!] Installing Dependencies............$G DONE"
    echo
    echo -e $Y" [*] Setting Lock......................."
    echo
    sleep 1
    echo -e $G" [!] Authentication Required\r $U"
    sleep 1

    #Test if fingerprint working.
    termux-fingerprint | grep -q "AUTH_RESULT_SUCCESS"

    #if true set lock
    if [ $? -eq 0 ]; then
        sed -i '2 a termux-fingerprint -c Exit | grep -q "AUTH_RESULT_SUCCESS"; [ $? -ne 0 ] && exit' $FILE
        sleep 2
        echo -e $Y" [!] Setting Lock.......................$G DONE"
        echo
        echo "                                   "

    #else skip setup and exit
    else
        echo -e $Y" [!] Setting Lock.......................$R ERR"
        echo
        echo -e $R" [!] Exiting...                               "
        exit 1
    fi
fi
