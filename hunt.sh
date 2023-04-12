#!/usr/bin/bash

#Colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
light_gray='\033[0;37m'
dark_gray='\033[1;30m'
light_red='\033[1;31m'
light_green='\033[1;32m'
yellow='\033[1;33m'
light_blue='\033[1;34m'
light_purple='\033[1;35m'
light_cyan='\033[1;36m'
white='\033[1;37m'
nc='\033[0m' # No Color

if [ -z $1 ];
then
	echo "please select an argument [-h,-u,-l,-w,-wl]"
	exit 1

elif [ $1 == "-h" ];
then
	echo "hunt is Recon Script

the Usage Command is ./hunt [arg]

args
	-h = help
	-u = single host
	-l = list of hosts
	-w = wildcard host
	-wl = list of wildcards"

elif [ $1 == "-w" ];
then
	#TARGET
	echo -e "${light_blue}What's the Target Domain${nc}"
	read domain
	clear

        #BANNER
        echo -e "${yellow}"
        figlet -f Speed hunter -c

	echo -e "${yellow}TARGET: "$domain"${nc}"
	echo -e "${yellow}TARGET: "$domain"${nc}" | notify -silent &> /dev/null

	#TARGET DIRECTORY
	mkdir /root/recon/$domain && cd /root/recon/$domain
	echo -e "${yellow}Created Directory for the Target in /root/recon/"$domain"${nc}"
	echo -e "${yellow}Created Directory for the Target in /root/recon/"$domain"${nc}" | notify -silent &> /dev/null
	mkdir roots && cd roots
	echo ""

	#SUBDOMAIN ENUMERATION
echo -e "${light_blue}###################
# Passive Sources #
###################
${nc}"

	#SLACK VERSION
       	echo "##Passive Sources##" | notify -silent &> /dev/null

	#GITHUB-SUBDOMAINS
	echo -e "${yellow}#Github${nc}"
	echo -e "${yellow}#Github${nc}" | notify -silent &> /dev/null
	github_subs=$(github-subdomains -d $domain -t $github_token -o github_subs &> /dev/null && cat github_subs | wc -l)
	echo -e "${light_red}"$github_subs" Subs
${nc}"
	echo -e "${light_red}"$github_subs" Subs${nc}" | notify -silent &> /dev/null

	#AMASS
	echo -e "${yellow}#Amass${nc}"
	echo -e "${yellow}#Amass${nc}" | notify -silent &> /dev/null
	amass_subs=$(amass enum -passive -d $domain -config /root/.config/amass/config.ini -o amass_subs &> /dev/null && cat amass_subs | wc -l)
	echo -e "${light_red}"$amass_subs" Subs
${nc}"
	echo -e "${light_red}"$amass_subs" Subs${nc}" | notify -silent &> /dev/null

	#SUBFINDER
	echo -e "${yellow}#Subfinder${nc}"
	echo -e "${yellow}#Subfinder${nc}" | notify -silent &> /dev/null
	subfinder_subs=$(subfinder -d $domain -all -pc /root/.config/subfinder/provider-config.yaml -o subfinder_subs &> /dev/null && cat subfinder_subs | wc -l)
	echo -e "${light_red}"$subfinder_subs" Subs
${nc}"
	echo -e "${light_red}"$subfinder_subs" Subs${nc}" | notify -silent &> /dev/null

	#ASSETFINDER
	echo -e "${yellow}#Assetfinder${nc}"
	echo -e "${yellow}#Assetfinder${nc}" | notify -silent &> /dev/null
	assetfinder_subs=$(assetfinder --subs-only $domain | anew -q assetfinder_subs && cat assetfinder_subs | wc -l)
	echo -e "${light_red}"$assetfinder_subs" Subs
${nc}"
	echo -e "${light_red}"$assetfinder_subs" Subs${nc}" | notify -silent &> /dev/null

	#FINDOMAIN
	echo -e "${yellow}#Findomain${nc}"
	echo -e "${yellow}#Findomain${nc}" | notify -silent &> /dev/null
	findomain_subs=$(findomain -t $domain -u findomain_subs &> /dev/null && cat findomain_subs | wc -l)
	echo -e "${light_red}"$findomain_subs" Subs
${nc}"
	echo -e "${light_red}"$findomain_subs" Subs${nc}" | notify -silent &> /dev/null

	#GAUPLUS
	echo -e "${yellow}#GauPlus${nc}"
        echo -e "${yellow}#GauPlus${nc}" | notify -silent &> /dev/null
	gauplus_subs=$(gauplus -t 5 -random-agent -subs $domain |  unfurl -u domains | anew -q gauplus_subs && cat gauplus_subs | wc -l)
	echo -e "${light_red}"$gauplus_subs" Subs
${nc}"
	echo -e "${light_red}"$gauplus_subs" Subs${nc}" | notify -silent &> /dev/null

	#WAYBACKURLS
	echo -e "${yellow}#Waybackurls"
        echo -e "${yellow}#Waybackurls" | notify -silent &> /dev/null
	waybackurls_subs=$(waybackurls $domain |  unfurl -u domains | sort -u | anew -q waybackurls_subs && cat waybackurls_subs | wc -l)
	echo -e "${light_red}"$waybackurls_subs" Subs
${nc}"
	echo -e "${light_red}"$waybackurls_subs" Subs${nc}" | notify -silent &> /dev/null

	#RAPID7 DATABASE
	echo -e "${yellow}#Rapid7 Database${nc}"
        echo "#Rapid7 Database" | notify -silent &> /dev/null
	crobat_subs=$(crobat -s $domain | anew -q crobat_subs && cat crobat_subs | wc -l)
	echo -e "${light_red}"$crobat_subs" Subs
${nc}"
	echo $crobat_subs" Subs" | notify -silent &> /dev/null

	#TOTAL
	echo -e "${yellow}#Total${nc}"
	echo "#Total" | notify -silent &> /dev/null
	subs=$(cat github_subs amass_subs subfinder_subs assetfinder_subs findomain_subs gauplus_subs waybackurls_subs crobat_subs | anew subs | wc -l)
	rm github_subs amass_subs subfinder_subs assetfinder_subs findomain_subs gauplus_subs waybackurls_subs crobat_subs
	echo -e "${light_red}"$subs" Total Subs
${nc}"
        echo $subs" Total Subs" | notify -silent &> /dev/null

        #Certificate Logs
        echo -e "${light_blue}####################
# Certificate Logs #
####################
${nc}"
	echo "##Certificate Logs##" | notify -silent &> /dev/null

        #CTFR
        echo -e "${yellow}#CTFR${nc}"
        echo "#CTFR" | notify -silent &> /dev/null
        ctfr_subs=$(python3 /root/tools/ctfr/ctfr.py -d $domain -o ctfr_subs &> /dev/null && cat ctfr_subs | wc -l)
        echo -e "${light_red}"$ctfr_subs" Subs
${nc}"
	echo $ctfr_subs" Subs" | notify -silent &> /dev/null

	#TOTAL
	echo -e "${yellow}#Total${nc}"
	echo "#Total" | notify -silent &> /dev/null
	subs=$(cat ctfr_subs | anew -q subs && cat subs | wc -l)
	rm ctfr_subs
	echo -e "${light_red}"$subs" Total Subs
${nc}"
	echo $subs" Total Subs" | notify -silent &> /dev/null

        #Recursive Enumeration
        echo -e "${light_blue}#########################
# Recursive Enumeration #
#########################
${nc}"
        echo "##Recursive Enumeration##" | notify -silent &> /dev/null
	recursive_subs=$( ( cat subs | rev | cut -d '.' -f 3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 && cat subs | rev | cut -d '.' -f 4,3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 ) | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2 | wc -l) 
        echo -e "${yellow}#"$recursive_subs" Subdomains to Enumerate${nc}"
        echo "#"$recursive_subs" Subdomains to Enumerate" | notify -silent &> /dev/null
        for sub in $( ( cat subs | rev | cut -d '.' -f 3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 && cat subs | rev | cut -d '.' -f 4,3,2,1 | rev | sort | uniq -c | sort -nr | grep -v '1 ' | head -n 10 ) | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 2 | wc -l);do
                passive_recursive=$(subfinder -d $sub -all -pc /root/.config/subfinder/provider-config.yaml -silent | anew passive_recursive | wc -l)
                passive_recursive=$(assetfinder --subs-only $sub | anew passive_recursive | wc -l)
                passive_recursive=$(amass enum -passive -d $sub -config /root/.config/amass/config.ini -silent | anew passive_recursive | wc -l)
                findomain --quiet -t $sub -o &> /dev/null
                find $sub.txt &> /dev/null
                if [ $(echo $?) -eq 0 ];
                then
                        passive_recursive=$(cat $sub.txt | anew passive_recursive | wc -l)
                        rm $sub.txt
                else
                        passive_recursive=0
                fi
        done

        passive_recursive=$(cat passive_recursive | wc -l)
        echo -e "${light_red}"$passive_recursive" Subs
${nc}"
        echo $passive_recursive" Subs" | notify -silent &> /dev/null

        #TOTAL
        echo -e "${yellow}#Total${nc}"
        echo "#Total" | notify -silent &> /dev/null
        subs=$(cat passive_recursive | anew -q subs && cat subs | wc -l)
        rm passive_recursive
        echo -e "${light_red}"$subs" Total Subs
${nc}"
        echo $subs" Total Subs"| notify -silent &> /dev/null

	#DNS BRUTEFORCING
	echo -e "${light_blue}####################
# DNS Bruteforcing #
####################
${nc}"
	echo "##DNS Bruteforcing##" | notify -silent &> /dev/null

	echo -e "${yellow}#Puredns${nc}"
	echo "#Puredns" | notify -silent &> /dev/null
	dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o resolvers &> /dev/null
	dns_subs=$(puredns bruteforce /root/lists/best-dns-wordlist.txt $domain -r resolvers -w dns_subs -q &> /dev/null && cat dns_subs | wc -l)
	echo -e "${light_red}"$dns_subs" Subs
${nc}"
	echo $dns_subs" Subs" | notify -silent &> /dev/null

        #TOTAL
        echo -e "${yellow}#Total${nc}"
	echo "#Total" | notify -silent &> /dev/null
        subs=$(cat dns_subs | anew -q subs && cat subs | wc -l)
	rm dns_subs
        echo -e "${light_red}"$subs" Total Subs
${nc}"
        echo $subs" Total Subs" | notify -silent &> /dev/null

	#PERMUTATION
	echo -e "${light_blue}###############
# Permutation #
###############
${nc}"
	echo "##Permutation##" | notify -silent &> /dev/null

	echo -e "${yellow}#Generate Permutation List - Gotator${nc}"
	echo "#Generate Permutation List - Gotator" | notify -silent &> /dev/null
	permutations=$(gotator -sub subs -perm /root/lists/raw -depth 1 -numbers 10 -mindup -adv -md -silent > permutations.txt && cat permutations.txt | wc -l)
	echo -e "${light_red}"$permutations" Combinantion
${nc}"
	echo $permutations" Combinantion" | notify -silent &> /dev/null

	echo -e "${yellow}#DNS Resolving - Puredns${nc}"
	echo "#DNS Resolving - Puredns" | notify -silent &> /dev/null
	permutation_subs=$(puredns resolve permutations.txt -r resolvers -w permutation_subs -q &> /dev/null && cat permutation_subs | wc -l)
	echo -e "${light_red}"$permutation_subs" Subs
${nc}"
	echo $permutation_subs" Subs" | notify -silent &> /dev/null

	#TOTAL
	echo -e "${yellow}#Total${nc}"
	echo "#Total" | notify -silent &> /dev/null
	subs=$(cat permutation_subs | anew -q subs && cat subs | wc -l)
	rm permutation_subs
	echo -e "${light_red}"$subs" Total Subs
${nc}"
	echo $subs" Total Subs" | notify -silent &> /dev/null

	#Scraping
	echo -e "${light_blue}############
# Scraping #
############
${nc}"
	echo "##Scraping##" | notify -silent &> /dev/null

	echo -e "${yellow}#Web probing subdomains - Httpx${nc}"
	echo "#Web probing subdomains - Httpx" | notify -silent &> /dev/null
	httpx_hosts=$(cat subs | httpx -random-agent -retries 2 -no-color -o hosts -silent &> /dev/null && cat hosts | wc -l)
	echo -e "${light_red}"$httpx_hosts" Alive Hosts
${nc}"
	echo $httpx_hosts" Alive Hosts" | notify -silent &> /dev/null

	echo -e "${yellow}#Crawling - Gospider${nc}"
	echo "#Crawling - Gospider" | notify -silent &> /dev/null
	gospider -S hosts --js -t 50 -d 3 --sitemap --robots -w -r -o gospider_subs &> /dev/null

	echo -e "${yellow}#Cleaning the output${nc}"
	echo "#Cleaning the output" | notify -silent &> /dev/null
	gospider_subs=$(cat gospider_subs/* | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains | grep "."$domain"$" | sort -u > scrap_subs && cat scrap_subs | wc -l)
	echo -e "${light_red}"$gospider_subs" Subs
${nc}"
        echo $gospider_subs" Subs" | notify -silent &> /dev/null


	echo -e "${yellow}#DNS Resolving - Puredns${nc}"
	echo "#DNS Resolving - Puredns" | notify -silent &> /dev/null
	scrap_subs=$(puredns resolve scrap_subs -w scrap_subs_resolved -r resolvers -q &> /dev/null && cat scrap_subs_resolved | wc -l)
	echo -e "${light_red}"$scrap_subs" Subs
${nc}"
	echo $scrap_subs" Subs" | notify -silent &> /dev/null

        #TOTAL
        echo -e "${yellow}#Total${nc}"
        echo "#Total" | notify -silent &> /dev/null
        subs=$(cat scrap_subs_resolved | anew -q subs && cat subs | wc -l)
	rm -rf hosts gospider_subs scrap_subs scrap_subs_resolved
        echo -e "${light_red}"$subs" Total Subs
${nc}"
        echo $hosts" Total Subs" | notify -silent &> /dev/null

fi
