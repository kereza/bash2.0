#! /bin/bash

function client()
{
varu=0
varn=0
wtf=`cat tcpdump2 | gawk -F " " {'print $3'} | gawk -F "." {'print $1,$2,$3,$4'} | sed 's/ /./g' | sort | uniq | wc -l`

for m in `cat tcpdump2  | gawk -F " " {'print $3,$8'} | gawk -F "." {'print $1,$2,$3,$4,$5'} | gawk -F " " {'print $1,$2,$3,$4,$6'} | sed 's/ /./g'`
do
        ips=$(echo $m | gawk -F "." {'print $1,$2,$3,$4'} | sed 's/ /./g')
        num=$(echo $m | gawk -F "." {'print $5'})
        realarray[$varu]=$ips
        varu=`expr $varu + 1`
        numbers[$varn]=$num
        varn=`expr $varn + 1`
        while [ $wtf -gt 0 ]
        do
                uip=`cat tcpdump2 | gawk -F " " {'print $3'} | gawk -F "." {'print $1,$2,$3,$4'} | sed 's/ /./g' | sort | uniq | sed -n "$wtf p"`
                uniqarray[$wtf]=$uip
                wtf=`expr $wtf - 1`
        done
done


for number in ${!uniqarray[@]}
do
        asd=0
        for real in ${!realarray[@]}
        do
                if [ ${uniqarray[$number]} == ${realarray[$real]} ]
                then
                        asd=`expr $asd + ${numbers[$real]}`
                fi
        done
echo ${uniqarray[$number]} | tr '\n' ' '
echo $asd
done | gawk -F " " {'print $2, $1'} | sort -nr | head -n 10

}

function receive()
{
var1=0

for i in `cat tcpdump2 | gawk -F " " {'print $5'} | sed 's/.2424:/ /g' | sort | uniq -c | sort | tail -n 10 | sort -r`
do
        basicarray[$var1]=$i
        var1=`expr $var1 + 1`

done

echo "-----------------------"
echo "Servers |-->| Nu Packets"
echo "-----------------------"

for n in ${!basicarray[@]}
do
        if [ `expr $n % 2` -ne 0 ]
        then
                echo ${basicarray[`expr $n - 1`]}
        else
                echo  -n ${basicarray[`expr $n + 1`]} "--> "
        fi
done
}

function small()
{
var3=0

for m in `cat tcpdump2 | gawk -F " " {'print $8'}`
do
        numberarray[$var3]=$m
        var3=`expr $var3 + 1`
done

small=0
large=0

for n in ${numberarray[@]}
do
        last=${#numberarray[@]}
        if [ $n -lt 512 ]
        then
                small=`expr $small + 1`
        else
                large=`expr $large + 1`
        fi
done

qwe=$(bc <<< "scale=4;$small/$last*100")
zxc=$(bc <<< "scale=4;$large/$last*100")

echo "The percentage of \"small packets\" (maximum 512 bytes) is: $qwe%"
echo "Percentage of \"large packets\" (over 512 bytes) is $zxc%"

}

usage() {
cat << EOF
usage: $0 options

This script is parsing tcpdump output, providing you with a friendly easy to read output.

OPTIONS:
   -h   Show this help message
   -r   Top 10 servers receiving the most packets, showing the amount of packets received by each
   -s   Percentage of "small packets" (maximum 512 bytes) and Percentage of "large packets" (over 512 bytes)
   -c   Top 10 clients sending the most bytes, showing the IP address and the number of bytes sent for each
EOF
exit 0
}


case $1 in
         -r) receive
         ;;
         -h | --help) usage
         ;;
         -s) small
         ;;
         -c) client
         ;;
         esac
