#!/usr/bin/env bash

version=1.0.1

printf '\033[8;30;150t'

time_fore=$((1 + $RANDOM % 28))
time_news=$((30 + $RANDOM % 29))
time_evc=$((1 + $RANDOM % 58))

last_build=2020/12/10
at=9:45
header=".VFF Downloader for Dolphin - Created by Noah Pistilli (c) Copyright Noah Pistilli "
header2="------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
path='~/Library/Application\ Support/Dolphin/Wii'

function check_dependency {
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

function check_dependencies {
	check_dependency crontab cron
	check_dependency curl
}


function main {
	 clear
	 printf "\n$header\n$header2\n\n.VFF Downloader for Dolphin\n\n1. Start\n2. Quit\n$del\n\nDo you have problems or want to contact us?\nMail us at support@riiconnect24.net or join our Discord Server.\n\n"
	 read -p "Type a number that you can see above next to the command and hit ENTER: " p
}

if [ -e ~/.vff/vff_fore.txt ] || [ -e ~/.vff/vff_evc.txt ]
then
	del="3. Delete VFF Downloader files"
	check_dependencies
	main
else
	check_dependencies
	main
fi

function reg_select {
	clear
	printf "\n$header\n$header2\n\nChoose the region of your emulated Wii Menu\n\n1. USA\n2. Europe\n3. Japan\n\n"
	read -p "Choose: " s

	case $s in
		1) reg=45; number_1 ;;
		2) reg=50; number_1 ;;
		3) reg=4a; number_1 ;;
	esac
}



function number_1 {
	clear
	printf "\n$header\n$header2\n\nWelcome to the installation process of RiiConnect24 VFF Downloader for Dolphin!\n\nThis program will allow you to use Forecast/News Channel and the Everybody Votes Channel on your Dolphin Emulator. NOTE: In order to use the Everybody Votes Channel, you need a SYSCONF file from a real Wii.\n\nFirst, we need to detect your Dolphin user files.\n\n1. Continue\n2. Exit\n\n"
	read -p "Choose: " b

	if [ "$b" == "1" ]; then dol_find
	elif [ "$b" == "2" ]; then exit; fi
}

function dol_find {
	if [ ! -d ~/Library/Application\ Support/Dolphin/Wii ]
	then
		clear
		printf "\n$header\n$header2\n\nEither I was not able to find your Dolphin's Wii NAND Root, or you selected the wrong region. Please select the options below to change the path where your Wii NAND Root is located or go back.\n\n1. Change Path\n2. Back\n\n"
		read -p "Choose: " s
		if [ "$s" == "1" ]; then chg_path; fi
		if [ "$s" == "2" ]; then reg_select; fi
	else
		sel_download
	fi
}

function chg_path {
	clear
	printf "\n$header\n$header2\n[*] Change Path\n\nGo into Dolphin, press Config, go to Paths, then copy and paste the path that is in Wii NAND Root here.\n(e.g. ~/Library/Application\ Support/Dolphin/Wii)\n\n"
	read -p "" path

	sel_download
}

function sel_download {
	clear
	printf "\n$header\n$header2\nWhat are we doing today?\n\n1. Forecast/News/Everybody Votes Channel\n\n2. Forecast/News Channels\n\n3. Everybody Votes Channel\n\n"
	read -p "Choose: " z
	if [ "$z" == 1 ] || [ "$z" == 3 ]; then dupli_prevent_evc; fi
	if [ "$z" == 2 ]; then dupli_prevent_fore; fi
}

function dupli_prevent_evc {
	clear
	if [ -e ~/.vff/vff_evc.txt ]
	then
		printf "\n$header\n$header2\n\nYou have already used this script. To prevent duplicate crontabs from being created, we are exiting the script for you.\n\n"
		exit
	else
		evc_find
	fi
}

function evc_find {
	clear
	if [ ! -d $path/title/00010001/48414a$reg ]
	then
		printf "\n$header\n$header2\n\nI could not find the Everybody Votes Channel on your computer. Please download it then try again. Press 1 to go back to the selection screen.\n\n"
		read -p "Press 1: " s
	fi
	if [ "$s" == 1 ] 
	then
		sel_download
	else
		evc_region_select
	fi
}

function evc_region_select {
	clear
	printf "\n$header\n$header2\n\n\
	--- Everybody Votes Channel Configuration ---\n\n\
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
	049: USA                     098: Portugal\n\
	052: Venezuela               105: Spain\n\
	065: Australia               107: Sweden\n\
	066: Austria                 108: Switzerland\n\
	067: Belgium                 110: United Kingdom\n\n" | fold -s -w "$(tput cols)"
	read -p "Choose: " a

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	if [ "$a" == 001 ] || [ "$a" == 010 ] || [ "$a" == 016 ] || [ "$a" == 018 ] || [ "$a" == 020 ] || [ "$a" == 021 ] || [ "$a" == 022 ] || [ "$a" == 025 ] || [ "$a" == 030 ] || [ "$a" == 036 ] || [ "$a" == 040 ] || [ "$a" == 042 ] || [ "$a" == 049 ] || [ "$a" == 052 ] || [ "$a" == 065 ] || [ "$a" == 066 ] || [ "$a" == 067 ] || [ "$a" == 074 ] || [ "$a" == 076 ] || [ "$a" == 077 ] || [ "$a" == 078 ] [ "$a" == 079 ] || [ "$a" == 082 ] || [ "$a" == 083 ] || [ "$a" == 088 ] || [ "$a" == 094 ] || [ "$a" == 095 ] || [ "$a" == 096 ] || [ "$a" == 097 ] || [ "$a" == 098 ] || [ "$a" == 105 ] || [ "$a" == 107 ] || [ "$a" == 108 ] || [ "$a" == 110 ] && [ "$z" == 1 ]; then (crontab -l; echo "$time_evc */6 * * * curl -s -S --insecure https://vt.wii.rc24.xyz/$a/wc24dl.vff --output "$path"/title/00010001/48414a$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_evc.txt; dupli_prevent_fore; fi
	if [ "$a" == 001 ] || [ "$a" == 010 ] || [ "$a" == 016 ] || [ "$a" == 018 ] || [ "$a" == 020 ] || [ "$a" == 021 ] || [ "$a" == 022 ] || [ "$a" == 025 ] || [ "$a" == 030 ] || [ "$a" == 036 ] || [ "$a" == 040 ] || [ "$a" == 042 ] || [ "$a" == 049 ] || [ "$a" == 052 ] || [ "$a" == 065 ] || [ "$a" == 066 ] || [ "$a" == 067 ] || [ "$a" == 074 ] || [ "$a" == 076 ] || [ "$a" == 077 ] || [ "$a" == 078 ] [ "$a" == 079 ] || [ "$a" == 082 ] || [ "$a" == 083 ] || [ "$a" == 088 ] || [ "$a" == 094 ] || [ "$a" == 095 ] || [ "$a" == 096 ] || [ "$a" == 097 ] || [ "$a" == 098 ] || [ "$a" == 105 ] || [ "$a" == 107 ] || [ "$a" == 108 ] || [ "$a" == 110 ] && [ "$z" == 3 ]; then (crontab -l; echo "$time_evc */6 * * * curl -s -S --insecure https://vt.wii.rc24.xyz/$a/wc24dl.vff --output "$path"/title/00010001/48414a$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_evc.txt; finish; fi
 }

function dupli_prevent_fore {
	clear
	if [ -e ~/.vff/vff_fore.txt  ]
	then
		printf "\n$header\n$header2\n\nYou have already used this script. To prevent duplicate crontabs from being created, we are exiting the script for you.\n\n"
		exit
	else
		fore_region
	fi
}

function fore_region {
	clear
	printf "\n$header\n$header2\n\n\
	--- Forecast Channel Configuration ---\n\\n\
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
	018: Canada                  030: Guatemala\n\
	\n\n\
	1: More Countries\n\\n" | fold -s -w "$(tput cols)"
read -p "Choose your region: " s

case $s in
	001) reg_name = "Japan"; forecast_jpn ;;
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

function fore_region2 {
	clear
	printf "\n$header\n$header2\n\n--- Forecast Channel Configuration ---\n\nNow, you need to choose your region to use with Forecast Channel from the list below.\n\n031: Guyana                  043: St. Kitts and Nevis\n032: Haiti                   044: St. Lucia\n033: Honduras                045: St. Vincent and the Grenadines\n034: Jamacia                 046: Suriname\n035: Martinique              047: Trinidad and Tobago\n036: Mexico                  048: Turks and Caicos Islands\n037: Monsterrat              049: United States\n038: Netherlands Antilles    050: Uraguay\n039: Nicaragua               051: US Virgin Islands\n040: Panama                  052: Venezuela\n041: Paraguay                065: Austraila\n042: Peru                    066: Austria\n\n1: More Countries\n\n2: Back\n\n"
	read -p "Choose your region:" s

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

function fore_region3 {
	clear
	printf "\n$header\n$header2\n\n--- Forecast Channel Configuration ---\n\nNow, you need to choose your region to use with Forecast Channel from the list below.\n\n067: Belgium       097: Poland\n074: Denmark       098: Portugal\n076: Finland       099: Romania\n078: France        105: Spain\n078: Germany       107: Sweden\n079: Greece        108: Switzerland\n082: Ireland       110: United Kingdom\n083: Italy\n088: Luxembourg\n094: Netherland\n095: New Zealand\n096: Norway\n\n1: Back\n\n"
	read -p "Choose your region:" s

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

function forecast_jpn {
	clear
	printf "\n$header\n$header2\n\n--- Forecast Channel Configuration ---\n\nThe region that you have chosen is: $reg_name\n\n0. Japanese\n1 <- Back\n\n"
	read -p "Choose your prefered Language:" s

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	if [ "$s" == "0" ]; then (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/0/001/wc24dl.vff --output $path/title/00010002/4841465a/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news; fi
	if [ "$s" == "1" ]; then fore_region_auto; fi
}

function forecast_ntsc {
	clear
	printf "\n$header\n$header2\n\n\
--- Forecast Channel Configuration ---\n\n\
The region that you have chosen is: $reg_name\n\n\
1. English\n\
3. French\n\
4. Spanish\n\
0 <- Back\n\n" | fold -s -w $(tput cols)
	read -p "Choose your prefered Language:" l

	if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	if [ "$l" == "1" ] || [ "$l" == "3" ] || [ "$l" == "4" ]; then (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/$l/$s/wc24dl.vff --output "$path"/title/00010002/48414645/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news; fi
	if [ "$l" == "0" ]; then fore_region_auto; fi
}

function forecast_eur {
clear
printf "\n$header\n$header2\n\n--- Forecast Channel Configuration ---\n\nThe region that you have chosen is: $reg_name\n\n1. English\n2.German\n3. French\n 4. Spanish\n5. Italian\n6. Dutch\n0 <- Back\n\n"
read -p "Choose your prefered Language:" l

if [ ! -d ~/.vff ]; then mkdir ~/.vff; fi
	if [ "$l" == "1" || [ "$l" == "2" ] || [ "$l" == "3" ] || [ "$l" == "4" ] || [ "$l" == "5" ] || [ "$l" == "6" ]; then (crontab -l; echo "$time_fore * * * * curl -s -S --insecure http://weather.wii.rc24.xyz/$l/$s/wc24dl.vff --output $path/title/00010002/48414650/data/"wc24dl.vff"") | sort - | uniq - | crontab -; echo 'prevents duplicate cron jobs in the vff downloader' > ~/.vff/vff_fore.txt; news; fi
	if [ "$l" == "0" ]; then fore_region_auto; fi
}

function news {
clear
printf "\n$header\n$header2\n\n--- News Channel Configuration ---\n\n0. Japanese\n1. English Europe\n2. German\n3. English USA\n4. French\n5. Italian\n6. Dutch\n7. Spanish\n\n"
read -p "This time, it's easier. Just choose the region/language for News Channel:" s

	if [ "$s" == "0" ]; then (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/0_Japan/wc24dl.vff --output $path/title/00010002/4841474a/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish; fi
	if [ "$s" == "1" ] || [ "$s" == "2" ] || [ "$s" == "5" ] || [ "$s" == "6" ]; then (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/"$s"_Europe/wc24dl.vff --output $path/title/00010002/48414750/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish; fi
	if [ "$s" == "3" ]; then (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/1_America/wc24dl.vff --output $path/title/00010002/48414745/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish; fi
	if [ "$s" == "4" ]; then (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/3_International/wc24dl.vff --output $path/title/00010002/484147$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish; fi
	if [ "$s" == "7" ]; then (crontab -l; echo "$time_news * * * * curl -s -S --insecure http://news.wii.rc24.xyz/v2/4_International/wc24dl.vff --output $path/title/00010002/484147$reg/data/"wc24dl.vff"") | sort - | uniq - | crontab -; finish; fi
 }

function finish {
	clear
	printf "\n$header\n$header2\n\nThank you for using the .VFF Downloader. The News and Forecast Channels will be ready within an hour, and the Everybody Votes Channel within the next 6 hours.\n\n"
	exit
}

function del_vff {
	clear
	printf "\n$header\n$header2\n\nAfter completing this, your computer will no longer download the .Vff files neccsarry for the Wiiconnect24 channels to work. Select the options below to proceed.\n\n1. Delete Forecast and News Channel Files\n\n2. Delete Everybody Vote Channel Files.\n\n3. Delete Everything\n\n4. Exit\n\n"
	read -p "Choose: " s

	case "$s" in
		1) crontab -l | grep -v 'curl -s -S --insecure http://weather.wii.rc24.xyz'  | crontab -; crontab -l | grep -v 'curl -s -S --insecure http://news.wii.rc24.xyz/v2'  | crontab -; rm -rf ~/.vff/vff_fore.txt; del_files_fin ;;
		2) crontab -l | grep -v 'curl -s -S --insecure https://vt.wii.rc24.xyz/018/wc24dl.vff'  | crontab -; rm -rf ~/.vff/vff_evc.txt; del_files_fin ;;
		3) crontab -l | grep -v 'curl -s -S --insecure http://weather.wii.rc24.xyz'  | crontab -; crontab -l | grep -v 'curl -s -S --insecure http://news.wii.rc24.xyz/v2'  | crontab -; crontab -l | grep -v 'curl -s -S --insecure https://vt.wii.rc24.xyz/018/wc24dl.vff'  | crontab -; rm -rf ~/.vff/vff_fore.txt; rm -rf ~/.vff/vff_evc.txt; del_files_fin ;;
		4) exit ;;
		*) printf "Invalid selection.\n"; sleep 2; del_vff ;;
	esac
}

function del_files_fin {
	clear
	printf "\n$header\n$header2\n\nThe crontab was successfully deleted from your computer. Your computer will no longer download files for the channel you selected.\n\n"
	exit
}

case "$p" in
  1) reg_select ;;
  2) exit ;;
  3) del_vff ;;
esac
