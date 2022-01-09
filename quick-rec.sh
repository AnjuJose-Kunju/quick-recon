#! /bin/bash
bold=`tput bold`
red=`tput setaf 1`
green=`tput setaf 2`
end=`tput sgr0`

echo " ___"
echo "|                            *           *                 "
echo "|-- |--| |--| _|_  |--| |,.' | |--- _|_  | |--- ----       "
echo "|   |__| |__|  |__ |--| |    | |  |  |__ | |  | |__|       "
echo "                   |                            .__| ....! "
echo -e "\033[1m\033[0\n"
read -p "~enter domain name: " domain
echo -e "\033[1mSearching for domain...\033[0\n"
mkdir $domain
echo "~whois search results for $domain"
whois_domain(){
 whois $domain > $domain/whois1.txt
 {
   grep -w "Domain Name" $domain/whois1.txt
   grep -w "Registrant" $domain/whois1.txt
   grep -w "Admin" $domain/whois1.txt
   grep -w "Registry" $domain/whois1.txt
   grep -w "Registrar" $domain/whois1.txt
 } > $domain/whois.txt
cat $domain/whois.txt
echo -e "\n${bold}${green}whois results stored in $domain/whois.txt${end}"
rm $domain/whois1.txt
}
touch $domain/email.txt

emailgrab(){
echo -e "\n${bold}Collecting email IDs. This may take some time...${end}\n"
wget -qNr -l 1 "$domain" -O "$domain/$domain.txt"
cat "$domain/$domain.txt" | grep -aoE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" >> $domain/email.txt
sort -u $domain/email.txt -o $domain/email.txt

if [[ $(cat $domain/email.txt | wc -l) == 0 ]]; then
echo -e "${bold}${red}No email IDs found!${end}"
rm $domain/email.txt
else
cat $domain/email.txt
echo -e "\n${bold}${green}Email IDs stored in $domain/email.txt${end}"
fi
rm $domain/$domain.txt
}
subdomain_finder()
{
echo -e "\n${bold}Finding subdomains using assetfinder is time consuming please wait...${end}\n"
assetfinder --subs-only $domain > $domain/subdomain_subs.txt
cat $domain/subdomain_subs.txt | httprobe  -prefer-https >  $domain/subdomain_alive.txt
cat $domain/subdomain_alive.txt | sort -u > $domain/subdomain_sorted.txt
count=$( wc -l < $domain/subdomain_sorted.txt )
cat $domain/subdomain_sorted.txt
echo "The total number of subdomains of $domain is $count"
echo -e "\n${bold}${green}Subdomains stored in $domain/subdomain_sorted.txt${end}"
rm $domain/subdomain_subs.txt
rm $domain/subdomain_alive.txt
}
if [[ $domain != "" ]]; then
whois_domain
emailgrab
subdomain_finder
 else
  echo "\n${bold}please enter a domain name${end}"
 fi
 
