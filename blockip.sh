#! /bin/bash

var1=0

for i in `netstat -napt | gawk -F " " {'print $5'} | grep -E '80|443' | gawk -F ":" {'print $1'} | uniq -c | sort -n | gawk -F " " {'print $2'}`
do
        ips[$var1]=$i
        var1=`expr $var1 + 1`
done

var2=0

for v in `netstat -napt | gawk -F " " {'print $5'} | grep -E '80|443' | gawk -F ":" {'print $1'} | uniq -c | sort -n | gawk -F " " {'print $1'}`
do
        numbers[$var2]=$v
        var2=`expr $var2 + 1`
done

last=`netstat -napt | gawk -F " " {'print $5'} | grep -E '80|443' | gawk -F ":" {'print $1'} | uniq -c | sort -n | gawk -F " " {'print $2'} | wc -l`

for n in $(seq 0 $last)
do
        if [[ ${numbers[$n]} -ge  40 ]]
        then
        /sbin/iptables -A INPUT -s ${ips[$n]} -j DROP
        fi
done

