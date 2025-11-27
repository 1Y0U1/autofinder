#!/bin/bash



if [ -z "$1" ] 
then 
echo "Usage ./autofinder <example.com>"
exit
fi

start=$(date +%s)

echo "[*] Starting autofinder"

# Subdomains Enumeration
echo "[*] Finding Subdomains" 
subfinder -d $1  -silent > subdomain.txt
dnsx -silent -d $1 -w usr/share/wordlists/amass/subdomains-top1mil-20000.txt >> subdomain.txt
cat subdomain.txt | sort -u | uniq -u > subdomains.txt   
a=`cat subdomains.txt | wc -l`
echo "[*] $a Subdoamins Found"
rm -rf subdomain.txt 

# Finding Working domains 

echo "[*] Finding Working Domains"

cat subdomains.txt | httpx -silent > domains.txt 
rm -rf subdomains.txt
rm -rf resume.cfg
echo "[*] Result Saved to domains.txt"
end=$(date +%s)
runtime=$((end - start))
echo "[*] Total time: $runtime seconds"