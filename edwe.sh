#!/bin/bash

versioninform=$(echo -e "\033[0;36medwe v1.6b Вт 13 фев 2018 18:28:43  \033[0m")
wbase=./w
pwbase=./
wbackup=$pwbase$(basename $wbase).bak

if [[ "$*" = "please give me infocode" ]]; then

cat <<- infocode

	120 - no one arguments entered
	121 - no patterns
	122 - $? -ne 0
	123 - $keypattern is empty
	124 - 
	125
	999 - infocode was displayed

infocode
exit 999
fi;

examples () 
{
cat <<- examp

examp
}

mbackupw ()
{
cp $wbase $wbackup
}

choosekey () {
case "$1" in
	-b) cp $wbackup $wbase
	;;
	-d) shift
	if [[ -z $1 ]]; then
	echo "No arguments"
	exit 120
	else
	    grep --color='always' -in "$1" $wbase
	    if [[ $? -eq "0" ]]; then
	    #echo -n "Delete patterns? y/n/m "
	    read -p "Delete patterns? y/n/m " -n 1
	    #echo
	    	if [[ $REPLY = 'y' ]]; then
	   	 mbackupw && sed -i '/'$1'/d' $wbase
	   	 elif [[ $REPLY = 'm' ]]; then
	   	 #echo -n "Enter pattern or number of string for deleting: "
	   	 read -p "Enter pattern or number of string for deleting: " keypattern
	    
	  		  if [[ -n $keypattern ]]; then
	    
	    	if [[ $keypattern =~ [[:digit:]] ]]; then
	    	mbackupw && sed -i "$keypattern"d $wbase
	    	else
	    	        
	    	grep --color='always' -i "$keypattern" $wbase
	    		if [[ $? -ne "0" ]]; then
	    		echo "No one patterns found!"
	    		exit 121
	    		else
	     	#echo -n "Delete patterns? y/n "
	    	read -p "Delete patterns? y/n " -n 1
	    	#echo
	    		if [[ $REPLY = 'y' ]]; then
	    		mbackupw && sed -i '/'$keypattern'/d' $wbase
	 	         fi;
	 	         fi;
	 	         fi;
	 	else
	 	exit 122
	    fi;
	    
	    fi;
	    else 
	    echo "No one patterns found!"
	    fi;
	 fi;
	;;
	-e) ${EDITOR-vi} $wbase
	;;
	-f) shift
	    grep --color='always' -i "$1" $wbase
	;;
	-h|--help) cat <<-usage
			
			$versioninform
	
			 -b - Backup from *.bak file
			 -d - Delete pattern (it will delete whole string)				
			 -e - Edit (default - vi editor)
			 -f - Find pattern
			 -h - Help
			 -r - Replace word
			 -t - View 10 last entries
			 -u - Undo (delete last string)
			 -v - View (default - less viewer)
			
		usage
	;;
	
	-r) shift
	    grep --color='always' -in "$1" $wbase
	    if [[ $? -eq "0" ]]; then
		read -p "Enter word for replacing: " wrdtorp
			if [[ -n $wrdtorp ]]; then
			grep --color='always' -in "$wrdtorp" $wbase
	    read -p "Enter word to replacing: "
	    	if [[ -n $REPLY ]]; then
		echo -n "Replace "$wrdtorp" to "$REPLY"? y/n "
		read -n 1 yn
				if [[ $yn == "y" ]]; then
	    	mbackupw && sed -i 's/'$wrdtorp'/'$REPLY'/' $wbase
		echo
				else
				echo
				exit 180
				fi;
			else
			echo "No words were entered"
			exit 181
			fi;
			
	    	else	
	    	echo "No words were entered"
	    	exit 123
	    	fi;
	    else 
	    echo "No one patterns found!"
	    exit 124
	    fi;
	;;
	-t) tail $wbase
	;;
	-u) mbackupw && sed -i '$d' $wbase && tail -3 $wbase
	;;
	-v) ${PAGER-less} $wbase
	;;
	esac
	exit 125;
	}

if [[ -n "$@" ]]; then
	if [[ "$1" =~ ^- ]]; then
	choosekey "$@"
	fi;
	
res=$(grep -io "$1" $wbase)

	if [[ "$res" != "$1" ]]; then
	mbackupw
	echo "$*" >> $wbase
	tail -3 $wbase
	else
	echo -e "\033[1;31mWords were not added, because it's exists in the list.\033[0m"
	fi;
	
else 
less -N $wbase
fi; 
exit 0
