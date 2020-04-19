#!/bin/bash
principal () {
echo
read -p "DOMAIN => " DOMAIN
if [ -z $DOMAIN ]
then
principal
fi
IP=$(host $DOMAIN | cut -d ' ' -f4 | head -n1)
if [ "$IP" = "found:" ]
then
principal
fi
WHOIS=$(whois $IP | grep "inetnum:" | cut -d ' ' -f6 | cut -d '/' -f1 | cut -d '.' -f1,2,3)
for ip in $(seq 1 254);
do
host $WHOIS.$ip | grep "domain name pointer"
sleep 0.15
done
principal
}
principal
