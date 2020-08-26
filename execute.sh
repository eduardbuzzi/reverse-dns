#!/bin/bash
principal () {
echo
read -p "DOMAIN => " DOMAIN
echo
if [ -z $DOMAIN ]
then
principal
fi
IP=$(host $DOMAIN | cut -d ' ' -f4 | head -n1)
echo "$IP" > /tmp/111
if [ "$IP" = "found:" ]
then
principal
fi
WHOIS=$(cat /tmp/111 | cut -d '.' -f1,2,3)
for ip in $(seq 1 254);
do
RAN=$(shuf -i 1-1000 -n1)
IPDNS=$(host $WHOIS.$ip | grep "domain name pointer" | cut -d ' ' -f1,5 >> /tmp/DN$RAN)
LINES=$(wc -l /tmp/DN$RAN | cut -d ' ' -f1)
for i in `seq 1 $LINES`
do
IP1=$(cat /tmp/DN$RAN | cut -d '.' -f4 | head -n$i | tail -n1)
IP2=$(cat /tmp/DN$RAN | cut -d '.' -f3 | head -n$i | tail -n1)
IP3=$(cat /tmp/DN$RAN | cut -d '.' -f2 | head -n$i | tail -n1)
IP4=$(cat /tmp/DN$RAN | cut -d '.' -f1 | head -n$i | tail -n1)
DNS=$(cat /tmp/DN$RAN | cut -d ' ' -f2 | sed 's/.$//' | head -n$i | tail -n1)
echo " || IP => $IP1.$IP2.$IP3.$IP4 || DNS => $DNS"
done
rm /tmp/DN$RAN
sleep 0.15
done
rm /tmp/111
principal
}
principal
