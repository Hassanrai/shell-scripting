#!/bin/bash
# ip config script





if [ "$1" == "-n" ]
then
		Resultlimit=Yes
		ResultSize=$2
		CaseID=$3
		filename=$4
		
elif [ "$1" == "-c" ] || [ $1 == "-2" ] || [ $1 == "-r" ] || [ $1 == "-F" ] || [ $1 == "-t" ] || [ $1 == "-f" ] || [ $1 == "-e" ]
then
		Resultlimit=No
		CaseID=$1
		filename=$2
		
else
		echo Wrong Input
		exit
fi
PrintMostAttempts()
{

if [ "$Resultlimit" == "Yes" ]
then
		echo PrintMostAttempts
		grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 | sort | uniq -c | sort -nr | awk '{print$2 " : " $1}' | head -n $2
else
		echo PrintMostAttempts
		grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 | sort | uniq -c | sort -nr | awk '{print$2 " : " $1}'
fi

}


PrintSuccessfulAttempts()
{

if [ $Resultlimit == "Yes" ]
then
	echo PrintMostSuccessfulAttempts
	grep 'HTTP/1.1" [1-3][0-2][0-8]' $1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -nr | awk '{print$2 " : " $1}'| head -n $2

else
	echo PrintMostSuccessfulAttempts
	grep 'HTTP/1.1" [1-3][0-2][0-8]' $1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -nr | awk '{print$2 " : " $1}' 
fi
}



PrintCommonCodes()
{

if [ $Resultlimit == "Yes" ]
then
	echo PrintCommonCodes
	echo Count of Address with specific Status-Code 
	cat $1 | cut -d ' ' -f1,9| sort | uniq -c| sort -gr| awk '{print$2","$3 " : " $1}' | head -n $2
	#cat $1 | cut -d ' ' -f9 | sort | uniq -c | sort -gr | head -n $2
else
	echo PrintCommonCodes
	echo Count of Address with specific Status-Code 
	cat $1 | cut -d ' ' -f1,9| sort | uniq -c| sort -gr | awk '{print$2","$3 " : " $1}' 
fi
}



PrintFailureCodes()
{

if [ $Resultlimit == "Yes" ]
then
	echo PrintCommonCodesforfailures only
	echo Count of Address with specific StatusCode that Fail
	grep 'HTTP/1.1" [4-5][0-9][0-9]' $1 | cut -d ' ' -f1,9| sort | uniq -c | sort -nr | awk '{print$2","$3 " : " $1}'  | head -n $2
	#grep 'HTTP/1.1" [4-5][0-9][0-9]' $1 | cut -d ' ' -f9| sort | uniq -c | sort -nr | head -n $2
else
	echo PrintCommonCodesforfailures only
	echo Count of Address with specific StatusCode that Fail
	grep 'HTTP/1.1" [4-5][0-9][0-9]' $1 | cut -d ' ' -f1,9| sort | uniq -c | sort -nr | awk '{print$2","$3 " : " $1}'  
fi

}



PrintIPWithMostBytes()
{	

if [ $Resultlimit == "Yes" ]
then
	echo "">Bytes
	cat $1 | awk '$10!="-"'| cut -d ' ' -f1,10 | sort -n >> Bytes
	cat Bytes| awk '{arr[$1]+=$2} END{for (i in arr) print i, arr[i]}' | sort -nrk 2| head -n $2 | awk 	'{print$1 " has consume total Bytes : " $2}'

else
	echo "">Bytes
	cat $1 | awk '$10!="-"'| cut -d ' ' -f1,10 | sort -n >> Bytes
	cat Bytes| awk '{arr[$1]+=$2} END{for (i in arr) print i, arr[i]}' | sort -nrk 2|  awk 	'{print$1 " has consume total Bytes : " $2}'
fi

}


PrintBlacklist()
{
	file=$1
	while IFS= read -r line
	do
	
	domain=$(dig -x "$line | cut -d ' ' -f1"  +short)
	#echo $domain
	if grep -Fxq "$domain" blacklist.txt
	then
   	 echo $line "-Blacklist"
	else
	 echo $line
	fi
	done <"$file"
}

case $CaseID in
	"-c" )
	#echo "Solution 1";;
	PrintMostAttempts $filename $ResultSize;;
	"-2")
	#echo "Solution 2!";;
	PrintSuccessfulAttempts $filename $ResultSize;;
	"-r")
	#echo "Solution 3!";;
	PrintCommonCodes $filename $ResultSize;;
	"-F")
	#echo "Solution 4!";;
	PrintFailureCodes  $filename $ResultSize;;
	"-t")
	#echo "Solution 5!";;
	PrintIPWithMostBytes  $filename $ResultSize;;
	"-e")
	#echo "Solution 6!";;
	PrintBlacklist $filename $ResultSize;;
	* )
	echo "wrong Input"
	esac







#catch valid ipaddresses count


#grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' thttpd.log | sort | uniq -c


#solution for question 1-final
#grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} -' $1 | sort | uniq -c | sort -nr | head -n $2

#solution for question 2-final
#grep 'HTTP/1.1" [1-3][0-2][0-8]' $1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} -' | sort | uniq -c | sort -nr 


#solution for question 2--
#echo ".......only with hardcore 200......"
#grep 'HTTP/1.1" 200' $1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} -' | sort | uniq -c | sort -nr


#solution for question 3
#cat $1 | cut -d ' ' -f9 | sort | uniq -c | sort -gr

#solution for question 3-includes ip-final
#cat $1 | cut -d ' ' -f1,9| sort | uniq -c| sort -gr

#solution for question 4-final
#grep 'HTTP/1.1" [4-5][0-9][0-9]' $1 | cut -d ' ' -f1,9| sort


#solution for question 5
#cat $1 | cut -d ' ' -f1,10| sort > Bytes

	#cat $1 | cut -d ' ' -f1,10| sort > Bytes
	#read Bytes
	#for $IP in (uniq)
	#do
	
	#done





