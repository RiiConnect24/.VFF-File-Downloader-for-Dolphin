#!/usr/bin/env bash

version=1.1

printf '\033[8;30;150t'

time_fore=$(($RANDOM % 28))
time_news=$((30 + $RANDOM % 29))
time_evc=$(($RANDOM % 58))

numbers=(001 010 016 018 020 021 022 025 030 036 040 042 049 052 065 066 067 074 076 077 078 079 082 083 088 094 095 096 097 098 105 107 108 110)

last_build=2020/01/20
at=6:20

header() {
    	clear
    	printf "\033[1m.VFF Downloader for Dolphin - Created by Noah Pistilli (c) Copyright 2021 Noah Pistilli\033[0m\nUpdated on $last_build at $at\n" | fold -s -w "$(tput cols)"
    	printf -- "=%.0s" $(seq "$(tput cols)") && printf "\n\n"
}

choose() {
	read -p "Choose: " s
}

path_finder() {
	case "$OSTYPE" in
		darwin*) path='~/Library/Application\ Support/Dolphin/Wii'; check_dependencies ;;
		linux*) path=~/.local/share/dolphin-emu/Wii; check_dependencies ;;
	esac
}

check_dependency() {
	if [ -z "$2" ]; then
		# Expect that the package name is the same as the command being searched for.
		package_name=$1
	else
		# The package name was specified to be different.
		package_name=$2
	fi

	if ! command -v $1 &> /dev/null; then echo >&2 "Cannot find the command $1. Please install a $package_name package with your package manager. Name of package may vary from distro to distro"
		 exit 1
	fi
}

check_dependencies() {
	check_dependency crontab cron
	check_dependency curl
}


main() {
	clear
	header
	printf ".VFF Downloader for Dolphin\n\n1. Start\n2. Quit\n$del\n\nDo you have problems or want to contact us?\nMail us at support@riiconnect24.net or join our Discord Server.\n\n" | fold -s -w "$(tput cols)"
	read -p "Choose " p
}

if [ -e ~/.vff/vff_fore.txt ] || [ -e ~/.vff/vff_evc.txt ]
then
	del="3. Delete VFF Downloader files"
	path_finder
	main
else
	path_finder
	main
fi

reg_select() {
	clear
	header
	printf "Choose the region of your emulated Wii Menu\n\n1. USA\n2. Europe\n3. Japan\n\n"
	choose

	case $s in
		1) reg=45; number_1 ;;
		2) reg=50; number_1 ;;
		3) reg=4a; number_1 ;;
	esac
}



number_1() {
	clear
	header
	printf "Welcome to the installation process of RiiConnect24 VFF Downloader for Dolphin!\n\nThis program will allow you to use Forecast/News Channel and the Everybody Votes Channel on your Dolphin Emulator\n\033[1mNOTE: In order to use the Everybody Votes Channel, you need a SYSCONF file from a real Wii.\n\n\033[0mFirst, we need to detect your Dolphin user files.\n\n1. Continue\n2. Exit\n\n" | fold -s -w "$(tput cols)"
	choose

	case $s in 
        	1) dol_find ;;
        	2) exit ;;
	esac
}

dol_find() {
	if [[ ! -d $path ]]
	then
		clear
		unset path
		case $OSTYPE in
      			darwin*) path=$(grep NANDRootPath ~/Library/Application\ Support/Dolphin/config/dolphin.ini | cut -d ' ' -f 3-10); dol_find2 ;;
                	linux*) if [[ -e .config/dolphin-emu/Dolphin.ini ]]
                        	then    
            				path=$(grep NANDRootPath .config/dolphin-emu/Dolphin.ini | cut -d ' ' -f 3-10)
                            		dol_find2
       				else
            				chg_path 
                       		 fi ;;
		esac
	else
		path=$(sed 's/ /\\ /g' <<< "$path") 
        	sel_download
	fi
}

dol_find2() {
    	if [[ ! -d $path ]] 
    	then 
        	chg_path
    	else 
        	path=$(sed 's/ /\\ /g' <<< "$path")
        	sel_download
    	fi 
}

function chg_path {
    	clear
    	header
    	printf "[*] Change Path\n\nGo into Dolphin, press Config, go to Paths, then copy and paste the path that is in Wii NAND Root here.\n(e.g. ~/Library/Application\ Support/Dolphin/Wii)\n\n"
    	read -p "" path
  
   	dol_find2
}


sel_download() {
	clear
	header
	printf "What are we doing today?\n\n1. Forecast/News/Everybody Votes Channel\n\n2. Forecast/News Channels\n\n3. Everybody Votes Channel\n\n"
	read -p "Choose: " z
	
	if [ "$z" == 1 ] || [ "$z" == 3 ]; then dupli_prevent_evc; fi
	if [ "$z" == 2 ]; then dupli_prevent_fore; fi
}

dupli_prevent_evc() {
	clear
	if [ -e ~/.vff/vff_evc.txt ]
	then
		header
		printf "You have already used this script. To prevent duplicate crontabs from being created, we are exiting the script for you.\n\n" 
		exit
	else
		evc_find
	fi
}

evc_find() {
	clear
	if [ ! -d $path/title/00010001/48414a$reg ]
	then
		header
		printf "I could not find the Everybody Votes Channel on your computer. We will be bringing you back to the selection screen. Please download EVC and try again.\n; sleep 4; sel_download" | fold -s -w "$(tput cols)"
	else
		evc_region_select
	fi
}

evc_region_select() {
	clear
	header
	printf "        \033[1m--- Everybody Votes Channel Configuration ---\033[0m\n\n\
	Now, you need to choose the region of the Emulated Wii Console to use with the Everybody Votes Channel\n\n\
	001: Japan                   074: Denmark\n\
	010: Argentina               076: Finland\n\
	016: Brazil                  077: France\n\
	018: Canada                  078: Germany\n\
	020: Chile                   079: Greece\n\
	021: Colombia                082: Ireland\n\
	022: Costa Rica              083: Italy\n\
	025: Ecuador                 088: Luxembourg\n\
	030: Guatemala               094: Netherlands\n\
	036: Mexico                  095: New Zeland\n\
	040: Panama                  096: Norway\n\
	042: Paraguay                097: Poland\n\
	049: United States           098: Portugal\n\
	052: Venezuela               105: Spain\n\
	065: Australia               107: Sweden\n\
	066: Austria                 108: Switzerland\n\
	067: Belgium                 110: United Kingdom\n\n" | fold -s -w "$(tput cols)"
	choose

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	
	for i in ${numbers[@]}; do
      		if [[ ${s#0} -eq ${i#0} ]]; then
         		(crontab -l; echo "$time_evc */6 * * * curl -s -S --insecure https://vt.wii.rc24.xyz/$i/wc24dl.vff --output "$path"/title/00010001/48414a$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab - 
			 echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_evc.txt
      		fi
   	done
  
   	if [ $z == 3 ]; then
		finish
	else
		dupli_prevent_fore
	fi
 
 }

dupli_prevent_fore() {
	clear
	if [ -e ~/.vff/vff_fore.txt ]
	then
		header
		printf "You have already used this script. To prevent duplicate crontabs from being created, we are exiting the script for you.\n\n"
		exit
	else
		fore_region 
	fi
}

fore_region() {
	clear
	header
	unset s
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	Now, you need to choose the region of the Emulated Wii Console to use with Forecast Channel from the list below.\n\n\
	001: Japan                   019: Cayman Islands\n\
	008: Anguilla                020: Chile\n\
	009: Antigua and Barbuda     021: Colombia\n\
	010: Argentina               022: Costa Rica\n\
	011: Aruba                   023: Dominica\n\
	012: Bahamas                 024: Dominican Republic\n\
	013: Barbados                025: Ecuador\n\
	014: Belize                  026: El Salvador\n\
	015: Bolivia                 027: French Guiana\n\
	016: Brazil                  028: Grenada\n\
	017: British Virgin Islands  029: Guadeloupe\n\
	018: Canada                  030: Guatemala\n\n\
	1: More Countries\n\n" | fold -s -w $(tput cols)
	choose 

	case $s in
		001) reg_name="Japan"; forecast_jpn ;;
		008) reg_name="Anguilla"; forecast_ntsc ;;
		009) reg_name="Antigua"; forecast_ntsc ;;
		010) reg_name="Argentina"; forecast_ntsc ;;
		011) reg_name="Aruba"; forecast_ntsc ;;
		012) reg_name="Bahamas"; forecast_ntsc ;;
		013) reg_name="Barbados"; forecast_ntsc ;;
		014) reg_name="Belize"; forecast_ntsc ;;
		015) reg_name="Bolivia"; forecast_ntsc ;;
		016) reg_name="Brazil"; forecast_ntsc ;;
		017) reg_name="British Virgin Islands"; forecast_ntsc ;;
		018) reg_name="Canada"; forecast_ntsc ;;
		019) reg_name="Cayman Islands"; forecast_ntsc ;;
		020) reg_name="Chile"; forecast_ntsc ;;
		021) reg_name="Colombia"; forecast_ntsc ;;
		022) reg_name="Costa Rica"; forecast_ntsc ;;
		023) reg_name="Dominica"; forecast_ntsc ;;
		024) reg_name="Dominican Republic"; forecast_ntsc ;;
		025) reg_name="Ecuador"; forecast_ntsc ;;
		026) reg_name="El Salvador"; forecast_ntsc ;;
		027) reg_name="Guiana"; forecast_ntsc ;;
		028) reg_name="Grenada"; forecast_ntsc ;;
		029) reg_name="Guadeloupe"; forecast_ntsc ;;
		030) reg_name="Guatemala"; forecast_ntsc ;;
		1) fore_region2 ;;
		* ) printf "Invalid selection.\n"; sleep 2; fore_region ;; 
	esac
}

fore_region2() {
	clear
	header
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	Now, you need to choose your region to use with Forecast Channel from the list below.\n\n\
	031: Guyana                   043: St. Kitts and Nevis\n\
	032: Haiti                    044: St. Lucia\n\
	033: Honduras                 045: St. Vincent and the Grenadines\n\
	034: Jamacia                  046: Suriname\n\
	035: Martinique               047: Trinidad and Tobago\n\
	036: Mexico                   048: Turks and Caicos Islands\n\
	037: Monsterrat               049: United States\n\
	038: Netherlands Antilles     050: Uraguay\n\
	039: Nicaragua                051: US Virgin Islands\n\
	040: Panama                   052: Venezuela\n\
	041: Paraguay                 065: Austraila\n\
	042: Peru                     066: Austria\n\n\
	1: More Countries\n\n\
	2: Back\n\n" | fold -s -w "$(tput cols)"
	choose

	case $s in
		031) reg_name="Guyana"; forecast_ntsc ;;
		032) reg_name="Haiti"; forecast_ntsc ;;
		033) reg_name="Honduras"; forecast_ntsc ;;
		034) reg_name="Jamaica"; forecast_ntsc ;;
		035) reg_name="Martinique"; forecast_ntsc ;;
		036) reg_name="Mexico"; forecast_ntsc ;;
		037) reg_name="Monsterrat"; forecast_ntsc ;;
		038) reg_name="Netherland Antilles"; forecast_ntsc ;;
		039) reg_name="Nicaragua"; forecast_ntsc ;;
		040) reg_name="Panama"; forecast_ntsc ;;
		041) reg_name="Paraguay"; forecast_ntsc ;;
		042) reg_name="Peru"; forecast_ntsc ;;
		043) reg_name="St. Kitts and Nevis"; forecast_ntsc ;;
		044) reg_name="St. Lucia"; forecast_ntsc ;;
		045) reg_name="St. Vincent and the Grenadines"; forecast_ntsc ;;
		046) reg_name="Suriname"; forecast_ntsc ;;
		047) reg_name="Trinidad and Tobago"; forecast_ntsc ;;
		048) reg_name="Turks and Caicos Islands"; forecast_ntsc ;;
		049) reg_name="United States"; forecast_ntsc ;;
		050) reg_name="Uruguay"; forecast_ntsc ;;
		051) reg_name="US Virgin Islands"; forecast_ntsc ;;
		052) reg_name="Venezuela"; forecast_ntsc ;;
		065) reg_name="Australia"; forecast_eur ;;
		066) reg_name="Austria"; forecast_eur ;;
		1) fore_region3 ;;
		2) fore_region ;;
		*) printf "Invalid selection.\n"; sleep 2; fore_region2 ;;
	esac
}

fore_region3() {
	clear
	header
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	Now, you need to choose your region to use with Forecast Channel from the list below.\n\n\
	067: Belgium       	      097: Poland\n\
	074: Denmark                  098: Portugal\n\
	076: Finland       	      099: Romania\n\
	078: France        	      105: Spain\n\
	078: Germany       	      107: Sweden\n\
	079: Greece        	      108: Switzerland\n\
	082: Ireland       	      110: United Kingdom\n\
	083: Italy\n\
	088: Luxembourg\n\
	094: Netherland\n\
	095: New Zealand\n\
	096: Norway\n\n\
	1: Back\n\n" | fold -s -w "$(tput cols)"
	choose

	case $s in
		067) reg_name="Belgium"; forecast_eur ;;
		074) reg_name="Denmark"; forecast_eur ;;
		076) reg_name="Finland"; forecast_eur ;;
		077) reg_name="France"; forecast_eur ;;
		078) reg_name="Germany"; forecast_eur ;;
		079) reg_name="Greece"; forecast_eur ;;
		082) reg_name="Ireland"; forecast_eur ;;
		083) reg_name="Italy"; forecast_eur ;;
		088) reg_name="Luxembourg"; forecast_eur ;;
		094) reg_name="Netherlands"; forecast_eur ;;
		095) reg_name="New Zealand"; forecast_eur ;;
		096) reg_name="Norway"; forecast_eur ;;
		097) reg_name="Poland"; forecast_eur ;;
		098) reg_name="Portugal"; forecast_eur ;;
		099) reg_name="Romania"; forecast_eur ;;
		105) reg_name="Spain"; forecast_eur ;;
		107) reg_name="Sweden"; forecast_eur ;;
		108) reg_name="Switzerland"; forecast_eur ;;
		110) reg_name="United Kingdom"; forecast_eur ;;
		1) fore_region2 ;;
		*) printf "Invalid selection.\n"; sleep 2; fore_region3 ;;
	esac
}

forecast_jpn() {
	clear
	header
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	The region that you have chosen is: $reg_name\n\n\
	0. Japanese\n\
	1 <- Back\n\n" | fold -s -w "$(tput cols)"
	choose

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	case $s in
		1) (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/0/001/wc24dl.vff --output $path/title/00010002/4841465a/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news ;;
	        2) fore_region ;;
		*) printf "Invalid selection.\n"; sleep 2; forecast_jpn ;;
    esac
}

forecast_ntsc() {
	clear
	header
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	The region that you have chosen is: $reg_name\n\n\
	1. English\n\
	3. French\n\
	4. Spanish\n\
	0 <- Back\n\n" | fold -s -w "$(tput cols)"
	read -p "Choose your prefered Language: " l

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	case $l in 
		1|3|4) (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/$l/$s/wc24dl.vff --output "$path"/title/00010002/48414645/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news ;;
		0) fore_region ;;
		*) printf "Invalid selection.\n"; sleep 2; forecast_ntsc ;;
	esac
	
}

forecast_eur() {
	clear
	header
	printf "        \033[1m--- Forecast Channel Configuration ---\033[0m\n\n\
	The region that you have chosen is: $reg_name\n\n\
	1. English\n\
	2.German\n\
	3. French\n\
	4. Spanish\n\
	5. Italian\n\
	6. Dutch\n\
	0 <- Back\n\n" | fold -s -w "$(tput cols)"
	read -p "Choose your prefered Language: " l

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	case $l in
		1|2|3|4|5|6) (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/$l/$s/wc24dl.vff --output $path/title/00010002/48414650/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news ;;
	        0) fore_region ;;
	        *) printf "Invalid selection.\n"; sleep 2; forecast_eur ;;
	esac
}

news() {
	clear
	header
	printf "        \033[1m--- News Channel Configuration ---\033[0m\n\n\
	0. Japanese\n\
	1. English Europe\n\
	2. German\n\
	3. English USA\n\
	4. French\n\
	5. Italian\n\
	6. Dutch\n\
	7. Spanish\n\n" | fold -s -w "$(tput cols)"
	read -p "This time, it's easier. Just choose the region/language for News Channel: " s

	case $s in 
		0) (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/0_Japan/wc24dl.vff --output $path/title/00010002/4841474a/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish ;;
		1|2|5|6) (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/"$s"_Europe/wc24dl.vff --output $path/title/00010002/48414750/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish ;;
		3) (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/1_America/wc24dl.vff --output $path/title/00010002/48414745/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish ;;
		4) (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/3_International/wc24dl.vff --output $path/title/00010002/484147$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish ;;
		7) (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/4_International/wc24dl.vff --output $path/title/00010002/484147$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish ;;
	  	*) printf "Invalid selection.\n"; sleep 2; news ;;
	esac
 }

finish() {
	clear
	header
	printf "Thank you for using the .VFF Downloader. The News and Forecast Channels will be ready within an hour, and the Everybody Votes Channel within the next 6 hours.\n\n"
	exit
}

del_vff() {
	clear
	header
	printf "After completing this, your computer will no longer download the .vff files necessary for the WiiConnect24 channels to work. Select the options below to proceed.\n\n\
	1. Delete Forecast and News Channel Files\n\n\
	2. Delete Everybody Vote Channel Files.\n\n\
	3. Delete Everything\n\n\
	4. Exit\n\n" | fold -s -w "$(tput cols)"
	choose

	case "$s" in
		1) crontab -l | grep -v 'curl -s -S --insecure http://weather.wii.rc24.xyz' | crontab -; crontab -l | grep -v 'curl -s -S --insecure http://news.wii.rc24.xyz/v2' | crontab -; rm -rf ~/.vff/vff_fore.txt; del_files_fin ;;
		2) crontab -l | grep -v 'curl -s -S --insecure https://vt.wii.rc24.xyz' | crontab -; rm -rf ~/.vff/vff_evc.txt; del_files_fin ;;
		3) crontab -l | grep -v 'curl -s -S --insecure http://weather.wii.rc24.xyz' | crontab -; crontab -l | grep -v 'curl -s -S --insecure http://news.wii.rc24.xyz/v2' | crontab -; crontab -l | grep -v 'curl -s -S --insecure https://vt.wii.rc24.xyz/018/wc24dl.vff' | crontab -; rm -rf ~/.vff/vff_fore.txt; rm -rf ~/.vff/vff_evc.txt; del_files_fin ;;
		4) exit ;;
		*) printf "Invalid selection.\n"; sleep 2; del_vff ;;
	esac
}

del_files_fin() {
	clear
	header
	printf "The crontab was successfully deleted from your computer. Your computer will no longer download files for the channel you selected.\n\n"
	exit
}

case "$p" in
	1) reg_select ;;
	2) exit ;;
	3) del_vff ;;
esac
