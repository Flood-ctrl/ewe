#!/bin/bash

#sed '/^$/d' w | sed 's/—/-/' | sed -i 's/[ ]*$//' | cat w | tr  A-Z a-z > w2 && mv w2 w


w=./w						            #Path to vocablurary
cnt=0									      #This counter for pause cyckle
intel=0									    #This counter for showing newest (last words)
declare -a ids							#This array for exclude repeating of words in cyckle
#pati=0

#This function for showing timer on stdout on pausecykle
function timercountdown () {
  echo
  echo -e -n "\033[1;31mPAUSE\033[0m "

  #Making cursor invisible
  tput civis

  #Show timercountdown in stdout
    for titosc in {299..0}; do
      read -s -t 1 -n 1
        if [[ $REPLY == "p" || $REPLY == "P" ]]; then
          #Make normal cursor
          tput cnorm
          break
        else
          #Save cursor position and restore cursor position
          tput sc
          echo -n $titosc
          tput rc
        fi;
      done
  echo
  tput cnorm
}

#Function for pause
function pausecyk () {
  echo
  echo -e -n "\033[1;31mPAUSE\033[0m "
  read -s -t 300 -n 1
  if [[ $REPLY == "p" || $REPLY == "P"  ]]; then
    read -s -t 0 -n 0
    echo
  else
    echo
    exit 202
  fi;
}

#Function for enter and exit from pausecyk
function pausecykcheck () {
  if [[ $cnt -eq 1 ]]; then
    timercountdown
  elif [[ $cnt -eq 2 ]]; then
    cnt=0
    $kindofcyk
  fi;
}

function ewe () {
  wo=$(shuf -n1 $w)
  echo -e "\n\033[1m\033[36m${wo}"
  read -s -t 100 -n 1 B
}

function ewecyk () {
  ewe
  for ((eq=1 ; eq<=100; eq++)) do
    if [ "$B" = "q" ]; then
      ewe
    fi;
  done
}

#This function for showing ramdom words from vocablurary
function ranewe () {
read -s -t 1
  #Checking for non-pressed key
  if [[ -z "$REPLY" ]]; then
    #Checking for showed pairs of words if it less then 10 it will show
    #words from last 25 pairs (newest pairs) else it will show random pairs
    #from vocablurary
    if [[ "$intel" -le 10 ]]; then
      s1=$(tail -25 $w | shuf -n1)
    else
    s1=$(shuf -n1 $w)
    fi;
      #If previous string equal current it will decrise counter rec
      #(number of outputet strings by default equal 100) and start again random outputet
      #But if it not equal it will add array and count nubmer of this strings
      #if count of strings greater then three (by default) it will start again random output
      if [[ $s2 == $s1 ]]; then
        ((--rec))
      else
        #Add string s1 to array
        IFS=$'\n' ids+=("$s1")
        sorted_ids=$(for elem in "${ids[@]}"; do
        echo ${elem}
        #Sort , uniq, delete spaces in begining of string, find string and output first column
        done | sort | uniq -c | sed 's/^[ ]*//' | grep $s1 | cut -f -1 -d " ")
          if [[ $sorted_ids -lt 3 ]]; then
            w1=$(echo "${s1}" | cut -f 1 -d - )
            w2=$(echo "${s1}" | cut -f 2 -d - )
            if [[ $kindofunc = ranewe ]]; then
              echo -ne "\n\033[1m\033[36m${w1}"
              read -s -t 3 -n 1 B
              echo "-"${w2}
            elif [[ $kindofunc = bkranewe ]]; then
              w2=$(echo $w2 | sed 's/^ //')
              echo -ne "\n\033[1m\033[36m${w2}"
              read -s -t 3 -n 1 B
              echo " -" ${w1}
            fi;
          else
            ((--rec))
          fi;
          s2=$s1
    fi;
  else
    exit 200
  fi;
}

function ranewecyk () {
  for ((rec=1; rec<=100; ++rec)) do
    if [[ -n "$B" ]]; then
      if [[ "$B" == "p" || "$B" == "P" ]] ; then
        ((--rec))
        ((++cnt))
        pausecykcheck
      else
        exit 201
      fi;
    else
      #echo $rec
      $kindofcyk
      ((++intel))
      if [[ "$intel" -gt 50 ]]; then
        intel=0
      fi;
    fi;
  done
}

if [[ -n "$1" ]]; then
  case $1 in
    -b) kindofcyk=ranewe
        kindofunc=bkranewe
        ranewecyk
    ;;

  	-h|--help) cat <<-usage

				ewe - this script for showing words from vocablurary

				If you execute script without arguments it's shows interactive choice
				You can pause script execution by pressing "P" or "p" button.

				-b) backewe (it will show second word from pair first)
				-h) help (--help)
				-s) ewe (it will show first and after second words)
				-v) verbose mode

	usage
	;;

	-s) kindofcyk=ranewe
	   	kindofunc=ranewe
	   	ranewecyk
	;;

	-q) ewecyk
	   	exit 199
	;;

	-v)
	;;

  esac
  exit 0;
  else
    echo -e "\033[1;31mChoose a mode q - all wards and s or b - frist and next second\033[0m"
	read -s -t 7 -n 1
	if [[ "$REPLY" = "s" ]]; then
	  kindofcyk=ranewe
	  kindofunc=ranewe
	  ranewecyk
	elif [[ "$REPLY" = "q" ]]; then
	  ewecyk
	elif [[ "$REPLY" = "b" ]]; then
	  kindofcyk=ranewe
	  kindofunc=bkranewe
	  ranewecyk
	else
	  exit 2
	fi;
fi;

exit 0