#! /bin/bash

function disksize ()
{
for server in `cat servers.txt`
do
        var1=0
        for size in `ssh $server "df -h" | gawk -F " " {'print $5'} | grep -v Use | gawk -F "%" {'print $1'}`
        do
                sizearray[$var1]=$size
                var1=`expr $var1 + 1`
        done

        var2=0
        for disk in `ssh $server "df -h" | gawk -F " " {'print $1'} | grep -v File`
        do
                diskarray[$var2]=$disk
                var2=`expr $var2 + 1`
        done

        last=`ssh $server "df -h" | gawk -F " " {'print $5'} | grep -v Use | gawk -F "%" {'print $1'} | wc -l`

        for n in $(seq 0 $last)
        do
                if [[ ${sizearray[$n]} -ge  90 ]]
                then
                        echo $server
                        echo "${diskarray[$n]}" "${sizearray[$n]}%"

                fi
        done
done
}

function apacheres ()
{
for server in `cat servers.txt`
do
        ssh $server "/opt/apache/bin/apachectl -t 2> /dev/null"
        if [[ $? -eq 0 ]]
        then
                ssh $server "/etc/init.d/httpd graceful 2> /dev/null"
        else
                echo "The syntax on server $server is not correct"

        fi
done
}

function swap ()
{
for server in `cat servers.txt`
do
        mem=$(ssh $server "free -m | tail -n 1 | gawk {'print \$3'}")
        if [[ $mem -ne 0 ]]
        then
                echo "The server $server used $mem MB of swap space"
        fi
done
}


function usage() {
cat << EOF
usage: $0 options

This script is able to remotely restart apache and present SWAP and space usage in friendly format

OPTIONS:
   -h   Show this help message
   -s   Show server with HDD above 90%
   -m   Show server with more than 0 SWAP
   -a   Restart apache on all servers graceful
EOF
exit 0
}


case $1 in
         -s) disksize
         ;;
         -h | --help) usage
         ;;
         -m) swap
         ;;
         -a) apacheres
         ;;
         esac
