@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
echo 	Starting up...
echo	The program is starting...
:: ===========================================================================
:: .VFF File Downloader for Dolphin
set version=1.0.8
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================

if exist temp.bat del /q temp.bat
:script_start
echo 	.. Setting up the variables
:: Window size (Lines, columns)
set mode=128,40
mode %mode%
set s=NUL
:: Variables
set /a detected=0
set /a incorrect_region=0
set /a temp=0
set /a evc_country_code=0
set user_name=%userprofile:~9%

set /a rc24patcher=0
if "%1"=="-RC24Patcher_assisted" set /a rc24patcher=1



:: Window Title
title .VFF File Downloader for Dolphin v%version% Created by @KcrPL

set last_build=2020/04/27
set at=00:52
:: ### Auto Update ###	
:: 1=Enable 0=Disable
:: Update_Activate - If disabled, patcher will not even check for updates, default=1
:: offlinestorage - Only used while testing of Update function, default=0
:: FilesHostedOn - The website and path to where the files are hosted. WARNING! DON'T END WITH "/"
:: MainFolder/TempStorage - folder that is used to keep version.txt and whatsnew.txt. These two files are deleted every startup but if offlinestorage will be set 1, they won't be deleted.
set /a Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://patcher.rc24.xyz/update/VFF-Downloader-for-Dolphin/v1

set MainFolder=%appdata%\VFF-Downloader-for-Dolphin
set TempStorage=%appdata%\VFF-Downloader-for-Dolphin\internet\temp
set config=%appdata%\VFF-Downloader-for-Dolphin\config

set header=.VFF File Downloader - (C) KcrPL v%version% (Compiled on %last_build% at %at%)

::There's no need to check for the existance of MainFolder here since md creates folders recursively
::(e. g. if TempStorage doesn't exist, it checks for MainStorage and creates it if it doesn't exist, then checks for the "internet" folder in there and creates it if it doesn't exist
::and so on and so forth)
if not exist "%TempStorage%" md "%TempStorage%"
if not exist "%config%" md "%config%"
:: Load background color from file if it exists
if exist "%appdata%\RiiConnect24Patcher\internet\temp\background_color.txt" for /f "usebackq" %%a in ("%appdata%\RiiConnect24Patcher\internet\temp\background_color.txt") do color %%a

if %rc24patcher%==1 goto 1

if exist "%config%\evc_country_code.txt" set /p evc_country_code=<"%config%\evc_country_code.txt"
if exist "%config%\evc_country_code.txt" if %evc_country_code%==1 goto begin_main_evc_update_notify

goto begin_main
:begin_main_evc_update_notify
cls
echo %header%
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   Notification.              
echo   /     \  
echo  /   ^^!   \ Welcome back^^! We've updated the app since you last visited us here. 
echo  --------- We now support Everybody Votes Channel.
echo.
echo            We will now help you configure the program. 
echo.
echo       Do you wish to continue?
echo       1. Continue   2. Go back to Main Menu    3. Exit
echo ---------------------------------------------------------------------------------------------------------------------------
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
set /p s=Choose: 
if %s%==1 goto begin_main_evc_update_1
if %s%==2 goto begin_main
if %s%==3 exit
goto begin_main_evc_update_notify

:begin_main_evc_update_1
cls
echo %header%
echo ----------------------------------------------------------------------------------------------------------------------------
echo.
echo Again, we're glad to see you again.
echo.
echo --- Everybody Votes Channel Configuration ---
if %incorrect_region%==1 (
echo.
echo :--------------------------------------------------:
echo : Incorrect region number. Choose a correct one.   :
echo :--------------------------------------------------:
)
set incorrect_region=0
echo.
echo Please choose a region to use with Everybody Votes Channel.
echo.
echo 016: Brazil         018: Canada         020: Chile
echo 021: Colombia       022: Costa Rica     025: Ecuador
echo 030: Guatemala      036: Mexico         040: Panama
echo 042: Peru           049: United States  052: Venezuela
echo 065: Australia      066: Austria        067: Belgium
echo 074: Denmark        076: Finland        077: France
echo 078: Germany        079: Greece         082: Ireland
echo 083: Italy          088: Luxembourg     094: Netherlands
echo 095: New Zealand    096: Norway         097: Poland
echo 098: Portugal       105: Spain          107: Sweden
echo 108: Switzerland    110: United Kingdom
echo.
set /p region=Choose your region: 
:1_detect_1_check
set region_name=NUL
if "%region%"=="016" set region_name=Brazil
if "%region%"=="018" set region_name=Canad
if "%region%"=="020" set region_name=Chile
if "%region%"=="021" set region_name=Colombia
if "%region%"=="022" set region_name=Costa Rica
if "%region%"=="025" set region_name=Ecuador
if "%region%"=="030" set region_name=Guatemala
if "%region%"=="036" set region_name=Mexico
if "%region%"=="040" set region_name=Panama
if "%region%"=="042" set region_name=Peru
if "%region%"=="049" set region_name=United States
if "%region%"=="052" set region_name=Venezuela
if "%region%"=="065" set region_name=Australia
if "%region%"=="066" set region_name=Austria
if "%region%"=="067" set region_name=Belgium 
if "%region%"=="074" set region_name=Denmark
if "%region%"=="076" set region_name=Finland
if "%region%"=="077" set region_name=France
if "%region%"=="078" set region_name=Germany
if "%region%"=="079" set region_name=Greece
if "%region%"=="082" set region_name=Ireland
if "%region%"=="083" set region_name=Italy
if "%region%"=="088" set region_name=Luxembourg
if "%region%"=="094" set region_name=Netherlands
if "%region%"=="095" set region_name=New Zealand
if "%region%"=="096" set region_name=Norway
if "%region%"=="097" set region_name=Poland
if "%region%"=="098" set region_name=Portugal
if "%region%"=="105" set region_name=Spain
if "%region%"=="107" set region_name=Sweden
if "%region%"=="108" set region_name=Switzerland
if "%region%"=="110" set region_name=United Kingdom

if "%region_name%"=="NUL" (
set incorrect_region=1
goto begin_main_evc_update_1
)
>"%config%\evc_country_code.txt" echo %region%
goto begin_main_evc_update_2

:begin_main_evc_update_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Alright, that's all I needed to know.
echo.
echo Sorry for taking your time, you can now come back to your work.
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Few things to note:
echo 	1) The changes will apply the next time .VFF Downloader is started. (After you restart your computer etc.)
echo.
echo 	2) Everybody Votes Channel will not work if you won't use the save file from your Wii.
echo    	If you don't have a Wii, I'm sorry but there's nothing you can do unless you find a save file.
echo.
echo 	3) If you need to get Everybody Votes Channel .WAD file, please run RiiConnect24 Patcher.
echo.
echo That's it, press anything to close the program.
pause>NUL
exit

:begin_main
cls
mode %mode%
echo %header%
echo              `..````
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+    .VFF Downloader for Dolphin
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN   1. Start
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd   2. Settings
if exist "%MainFolder%/VFF-Downloader-for-Dolphin.exe" echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   3. Run the VFF Downloader once.   
if exist "C:\Users\%user_name%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   4. Manage startup VFF Downloader
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:  Do you have problems or want to contact us?  
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.  Mail us at support@riiconnect24.net
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd   
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`
echo                                   -odhhhhyddmmmmmNNmhs/:`
echo                                     :syhdyyyyso+/-`
set /p s=Type a number that you can see above next to the command and hit ENTER: 
if %s%==1 goto begin_main1
if %s%==2 goto settings
if %s%==3 if exist "%MainFolder%/VFF-Downloader-for-Dolphin.exe" start "" "%MainFolder%/VFF-Downloader-for-Dolphin.exe" -run_once
if %s%==4 goto settings
if %s%==restart goto script_start
if %s%==exit exit
goto begin_main
:settings
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Settings
echo.
echo R. Return to main menu.
echo.
echo 1. Delete config file and delete VFF Downloader from startup.
echo 2. Delete VFF Downloader from startup
echo 3. If VFF Downloader is running, shut it down.
set /p s=Choose: 
if /i %s%==r goto begin_main
if %s%==1 call :settings_del_config
if %s%==2 call :settings_del_vff_downloader
if %s%==3 call :settings_taskkill

if %temp%==1 goto script_start

goto settings

:settings_del_config
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
::Delete it's direcory
rmdir /s /q "%appdata%\VFF-Downloader-for-Dolphin"
::And delete it out of the autostart dir
del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"

set /a temp=1

goto settings_end

:settings_del_vff_downloader
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
::And delete it out of the autostart dir
del /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
goto settings_end

:settings_taskkill
::Stop the downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
goto settings_end

:settings_end
echo Done^^!
pause
exit /b 0

:begin_main_download_curl
cls
echo %header%
echo.
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`    Downloading curl... Please wait.
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd    This can take some time...
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs   :-------------------------:
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+   
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:   File 1 [3.5MB] out of 1
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.   0%% [          ]
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`
echo                                   -odhhhhyddmmmmmNNmhs/:`
echo                                     :syhdyyyyso+/-`
::Try to download curl from our servers
call powershell -command (new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/curl.exe"', '"curl.exe"')
::If it downloaded successfully, continue on
if %errorlevel%==0 goto begin_main1
::If it didn't, display error message
goto begin_main_download_curl_error

:begin_main_download_curl_error
cls
echo %header%                                                                
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   ERROR.              
echo   /     \  There was an error while downloading curl.
echo  /   ^^!   \ Curl is used for downloading files from update server. 
echo  --------- Please restart your PC and try running the patcher again.
echo            If it won't work, please download curl and put it in a folder next to Install.bat 
echo.
echo       Press any key to open download page in browser and to return to menu. Remember to put the file next to Intall.bat
echo ---------------------------------------------------------------------------------------------------------------------------
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`                   
pause>NUL
start %FilesHostedOn%/curl.exe
goto begin_main

:begin_main1
::Curl returns 2 if it's called without arguments (CURLE_FAILED_INIT)
curl
::So if the errorlevel isn't 2 now, we know that curl doesn't exist
if not %errorlevel%==2 goto begin_main_download_curl

cls
echo %header%
echo.
echo              `..````                                     :-------------------------:
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`    Checking for updates...
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd   :-------------------------:
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+
echo             mmmmms smMMMMMMMMMmddMMmmNmNMMMMMMMMMMMM:
echo            `mmmmmo hNMMMMMMMMMmddNMMMNNMMMMMMMMMMMMM.
echo            -mmmmm/ dNMMMMMMMMMNmddMMMNdhdMMMMMMMMMMN
echo            :mmmmm-`mNMMMMMMMMNNmmmNMMNmmmMMMMMMMMMMd
echo            +mmmmN.-mNMMMMMMMMMNmmmmMMMMMMMMMMMMMMMMy
echo            smmmmm`/mMMMMMMMMMNNmmmmNMMMMNMMNMMMMMNmy.
echo            hmmmmd`omMMMMMMMMMNNmmmNmMNNMmNNNNMNdhyhh.
echo            mmmmmh ymMMMMMMMMMNNmmmNmNNNMNNMMMMNyyhhh`
echo           `mmmmmy hmMMNMNNMMMNNmmmmmdNMMNmmMMMMhyhhy
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`
echo                                   -odhhhhyddmmmmmNNmhs/:`
echo                                     :syhdyyyyso+/-`

::If updating is disabled, skip the whole update check
if %Update_Activate%==0 goto 1

::Define the updateVersion (so not that much error checking is needed)
set updateversion=0.0.0
::Delete possibly outdated version.txt, whatsnew.txt and announcement.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q
if exist "%TempStorage%\annoucement.txt" del /q "%TempStorage%\annoucement.txt"

:: Commands to download files from server.
::If the downloader isn't supposed to get files from local storage (Offlinestorage=0, debug feature), download the newest version, changelog and announcement
if %offlinestorage%==0 (
call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/whatsnew.txt" --output "%TempStorage%\whatsnew.txt"
call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/version.txt" --output "%TempStorage%\version.txt"
call curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/annoucement.txt" --output "%TempStorage%\annoucement.txt"
)

::Bind exit codes to errors here
::If curl got a "CURLE_COULDNT_RESOLVE_HOST" error, 99% of the time the user doesn't have an active internet connection
if "%errorlevel%"=="6" goto no_internet_connection

::Read out version.txt and store it in var updateVersion
if exist "%TempStorage%\version.txt" for /f "usebackq" %%a in ("%TempStorage%\version.txt") do set updateversion=%%a
::If the update version is equal to the current version
if "%updateversion%"=="%version%" (
::No update is needed, so set updateavailable to 0
set updateavailable=0
) else set updateavailable=1
::So if the two versions don't match, set updateavailable to 1 (For some reason I have to put this comment down here and not in the (), otherwise cmd just crashes)

::If there is an update available, notify the user
if %updateavailable%==1 goto update_notice

::And if there is no update, just continue on
goto 1
:update_notice
cls
echo %header%
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------
echo    /---\   An update is available.              
echo   /     \  An update for this program is available. We suggest updating the VFF Downloader to the latest version.
echo  /   ^^!   \ 
echo  ---------  Current version: %version%
echo             New version: %updateversion%
echo                       1. Update                      2. Dismiss               3. What's new in this update?
echo ------------------------------------------------------------------------------------------------------------------------------
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
set /p s=
if %s%==1 goto update_files
if %s%==2 goto 1
if %s%==3 call :whatsnew
goto update_notice

:update_files
cls
echo %header%
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------
echo    /---\   Updating.
echo   /     \  Please wait...
echo  /   ^^!   \ 
echo  --------- VFF Downloader will restart shortly... 
echo.  
echo.
echo ------------------------------------------------------------------------------------------------------------------------------
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
:update_1
::Download the update helper
curl -f -L -s -S --insecure "https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1/UPDATE/update_assistant.bat" --output "update_assistant.bat"
::If there was an error downloading, notify user
if not %errorlevel%==0 goto error_updating
::So if there wasn't an error, start it with a flag so it knows what to update
start update_assistant.bat -VFF_Downloader_Installer
exit
:error_updating
cls
echo %header%
echo.                                                                       
echo              `..````                                                  
echo              yNNNNNNNNMNNmmmmdddhhhyyyysssooo+++/:--.`                
echo              hNNNNNNNNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd                
echo              ddmNNd:dNMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs                
echo             `mdmNNy dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM+        
echo             .mmmmNs mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:                
echo             :mdmmN+`mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM.                
echo             /mmmmN:-mNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN            
echo             ommmmN.:mMMMMMMMMMMMMmNMMMMMMMMMMMMMMMMMd                 
echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy                 
echo             hmmmmh omMMMMMMMMMmhNMMMmNNNNMMMMMMMMMMM+                 
echo ------------------------------------------------------------------------------------------------------------------------------
echo    /---\   ERROR
echo   /     \  There was an error while downloading the update assistant.
echo  /   ^^!   \ 
echo  --------- Press any key to return to main menu.
echo.  
echo.
echo ------------------------------------------------------------------------------------------------------------------------------
echo           -mddmmo`mNMNNNNMMMNNNmdyoo+mMMMNmNMMMNyyys                  
echo           :mdmmmo-mNNNNNNNNNNdyo++sssyNMMMMMMMMMhs+-                  
echo          .+mmdhhmmmNNNNNNmdysooooosssomMMMNNNMMMm                     
echo          o/ossyhdmmNNmdyo+++oooooosssoyNMMNNNMMMM+                    
echo          o/::::::://++//+++ooooooo+oo++mNMMmNNMMMm                    
echo         `o//::::::::+////+++++++///:/+shNMMNmNNmMM+                   
echo         .o////////::+++++++oo++///+syyyymMmNmmmNMMm                   
echo         -+//////////o+ooooooosydmdddhhsosNMMmNNNmho            `:/    
echo         .+++++++++++ssss+//oyyysso/:/shmshhs+:.          `-/oydNNNy   
echo           `..-:/+ooss+-`          +mmhdy`           -/shmNNNNNdy+:`   
echo                   `.              yddyo++:    `-/oymNNNNNdy+:`        
echo                                   -odhhhhyddmmmmmNNmhs/:`             
echo                                     :syhdyyyyso+/-`
pause>NUL
goto begin_main

:whatsnew
cls
echo %header%
echo ------------------------------------------------------------------------------------------------------------------------------
echo.
::If the whatsnew.txt file exists
if exist "%TempStorage%\whatsnew.txt" (
echo What's new in update %updateversion%?
echo.
::Type it out
type "%TempStorage%\whatsnew.txt"
) else echo Error. What's new file is not available.
::Else, (if it doesn't exist) display error message
echo.
pause>NUL
exit /b 0

:1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Welcome to the installation process of RiiConnect24 VFF Downloader for Dolphin!
echo This program will allow you to use Forecast/News Channel on your Dolphin Emulator without the NEWS00006 error.
echo.
echo We're gonna assume your Dolphin Emulator is using the default NAND location.
echo.
echo 1. Continue
if %rc24patcher%==0 echo 2. Exit
if %rc24patcher%==1 echo 2. Return to RiiConnect24 Patcher.
set /p s=Choose: 
if %s%==1 goto 1_detect
if %s%==2 if %rc24patcher%==0 goto begin_main
if %s%==2 if %rc24patcher%==1 goto:EOF
goto 1
:1_detect

set /a using_default_location=1

FOR /F "tokens=2* skip=2" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal"') do set Documents_Folder=%%b

set fix_detect=0
echo %Documents_Folder% | findstr "%USERPROFILE%" && set /a fix_detect=1
echo %Documents_Folder% | findstr "OneDrive" && set /a fix_detect=0

::if %fix_detect%==1 if exist "%Documents_Folder%\Dolphin Emulator\Wii\title\00010002" set detected=1
::if %fix_detect%==0 if exist "%userprofile%\Documents\Dolphin Emulator\Wii\title\00010002" set detected=1

if %fix_detect%==1 (
	set Documents_Folder=!userprofile!
	>"%config%\path_to_install.txt" echo !Documents_Folder!\Documents\Dolphin Emulator\Wii\title\00010002
	)

if %fix_detect%==0 (
	set Documents_Folder=C:\Users\!username!\OneDrive
	>"%config%\path_to_install.txt" echo !Documents_Folder!\Documents\Dolphin Emulator\Wii\title\00010002
	)

goto 1_detect_1

:1_detect_0
:: Depreacted
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Hmm... I couldn't find your Dolphin user configuration folder.
echo Try running Dolphin and "Perform Online System Update" and then start News/Forecast Channel.
echo.
echo If it still won't work, choose "Set manually"
echo.
echo 1. Try again
echo 2. Set manually
if %rc24patcher%==0 echo 3. Exit
if %rc24patcher%==1 echo 3. Return to RiiConnect24 Patcher.
set /p s=Choose:
if %s%==1 goto 1_detect
if %s%==2 goto 1_detect_set
if %s%==3 if %rc24patcher%==0 goto 1
if %s%==3 if %rc24patcher%==1 goto:EOF
goto 1_detect_0
:1_detect_set
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo If you're using a different location for Wii's NAND memory on Dolphin, please set it here down below.
echo.
echo Default location:                "C:\Users\%username%\Documents\Dolphin Emulator\Wii\title\00010002"
echo ^(or if using Microsoft Account^): "C:\Users\%username%\OneDrive\Documents\Dolphin Emulator\Wii\title\00010002"
echo.
echo 	Make sure that the format of the location (folder structure) will remain the same, otherwise things will break.
echo.
set /p dolphin_location=Your location: 
echo %dolphin_location%> "%config%\path_to_install.txt"
set /a using_default_location=0
goto 1_detect_1
:1_detect_1
mode 128,45
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- Forecast Channel Configuration ---
echo.
echo Success^^! I've saved the Dolphin's NAND path for use later on.
echo.
if %using_default_location%==1 echo Current location: %Documents_Folder%\Dolphin Emulator\Wii\title\00010002
if %using_default_location%==0 echo Current location: %dolphin_location%
echo 	R. I'm using a different location for my NAND.

if %incorrect_region%==1 (
echo.
echo :--------------------------------------------------:
echo : Incorrect region number. Choose a correct one.   :
echo :--------------------------------------------------:
)
set incorrect_region=0
echo.
echo Now, you need to choose your region to use with Forecast Channel from the list below.
echo.
echo 001: Japan                    033: Honduras                       078: Germany
echo 008: Anguilla                 034: Jamaica                        079: Greece
echo 009: Antigua and Barbuda      035: Martinique                     082: Ireland
echo 010: Argentina                036: Mexico                         083: Italy
echo 011: Aruba                    037: Monsterrat                     088: Luxembourg
echo 012: Bahamas                  038: Netherlands Antilles           094: Netherlands
echo 013: Barbados                 039: Nicaragua                      095: New Zealand
echo 014: Belize                   040: Panama                         096: Norway
echo 015: Bolivia                  041: Paraguay                       097: Poland
echo 016: Brazil                   042: Peru                           098: Portugal
echo 017: British Virgin Islands   043: St. Kitts and Nevis            099: Romania
echo 018: Canada                   044: St. Lucia                      105: Spain
echo 019: Cayman Islands           045: St. Vincent and the Grenadines 107: Sweden
echo 020: Chile                    046: Suriname                       108: Switzerland
echo 021: Colombia                 047: Trinidad and Tobago            110: United Kingdom
echo 022: Costa Rica               048: Turks and Caicos Islands
echo 023: Dominica                 049: United States
echo 024: Dominican Republic       050: Uruguay
echo 025: Ecuador                  051: US Virgin Islands
echo 026: El Salvador              052: Venezuela
echo 027: French Guiana            065: Australia
echo 028: Grenada                  066: Austria
echo 029: Guadeloupe               067: Belgium
echo 030: Guatemala                074: Denmark
echo 031: Guyana                   076: Finland
echo 032: Haiti                    077: France
echo.
set /p region=Choose your region: 
if "%region%"=="r" goto 1_detect_set
if "%region%"=="R" goto 1_detect_set
goto 1_detect_1_check
:1_detect_1_check
set region_name=NUL
if "%region%"=="001" set region_name=Japan
if "%region%"=="008" set region_name=Anguilla
if "%region%"=="009" set region_name=Antigua and Barbuda
if "%region%"=="010" set region_name=Argentina
if "%region%"=="011" set region_name=Aruba
if "%region%"=="012" set region_name=Bahamas
if "%region%"=="013" set region_name=Barbados
if "%region%"=="014" set region_name=Belize
if "%region%"=="015" set region_name=Bolivia
if "%region%"=="016" set region_name=Brazil
if "%region%"=="017" set region_name=British Virgin Islands
if "%region%"=="018" set region_name=Canad
if "%region%"=="019" set region_name=Cayman Islands
if "%region%"=="020" set region_name=Chile
if "%region%"=="021" set region_name=Colombia
if "%region%"=="022" set region_name=Costa Rica
if "%region%"=="023" set region_name=Dominica
if "%region%"=="024" set region_name=Dominican Republic
if "%region%"=="025" set region_name=Ecuador
if "%region%"=="026" set region_name=El Salvador
if "%region%"=="027" set region_name=French Guiana
if "%region%"=="028" set region_name=Grenada
if "%region%"=="029" set region_name=Guadeloupe
if "%region%"=="030" set region_name=Guatemala
if "%region%"=="031" set region_name=Guyana
if "%region%"=="032" set region_name=Haiti
if "%region%"=="033" set region_name=Honduras
if "%region%"=="034" set region_name=Jamaica
if "%region%"=="035" set region_name=Martinique
if "%region%"=="036" set region_name=Mexico
if "%region%"=="037" set region_name=Monsterrat
if "%region%"=="038" set region_name=Netherlands Antilles
if "%region%"=="039" set region_name=Nicaragua
if "%region%"=="040" set region_name=Panama
if "%region%"=="041" set region_name=Paraguay
if "%region%"=="042" set region_name=Peru
if "%region%"=="043" set region_name=St. Kitts and Nevis
if "%region%"=="044" set region_name=St. Lucia
if "%region%"=="045" set region_name=St. Vincent and the Grenadines
if "%region%"=="046" set region_name=Suriname
if "%region%"=="047" set region_name=Trinidad and Tobago
if "%region%"=="048" set region_name=Turks and Caicos Islands
if "%region%"=="049" set region_name=United States
if "%region%"=="050" set region_name=Uruguay
if "%region%"=="051" set region_name=US Virgin Islands
if "%region%"=="052" set region_name=Venezuela
if "%region%"=="065" set region_name=Australia
if "%region%"=="066" set region_name=Austria
if "%region%"=="067" set region_name=Belgium 
if "%region%"=="074" set region_name=Denmark
if "%region%"=="076" set region_name=Finland
if "%region%"=="077" set region_name=France
if "%region%"=="078" set region_name=Germany
if "%region%"=="079" set region_name=Greece
if "%region%"=="082" set region_name=Ireland
if "%region%"=="083" set region_name=Italy
if "%region%"=="088" set region_name=Luxembourg
if "%region%"=="094" set region_name=Netherlands
if "%region%"=="095" set region_name=New Zealand
if "%region%"=="096" set region_name=Norway
if "%region%"=="097" set region_name=Poland
if "%region%"=="098" set region_name=Portugal
if "%region%"=="099" set region_name=Romania
if "%region%"=="105" set region_name=Spain
if "%region%"=="107" set region_name=Sweden
if "%region%"=="108" set region_name=Switzerland
if "%region%"=="110" set region_name=United Kingdom

if "%region_name%"=="NUL" (
set incorrect_region=1
goto 1_detect_1
)

mode %mode%
goto 2_detect_languages
:2_detect_languages
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- Forecast Channel Configuration ---
echo.
echo The region that you've chosen is: %region_name%.
echo.
echo Now... checking languages that you can use.
echo This can take some time.

::set %region_available_0%, %region_available_1%, %region_available_2%, ...  %region_available_6% to 0
for /L %%a in (0,1,6) do set region_available_%%a=0

::Use a loop to, well, loop through the numbers 0 to 6
for /L %%a in (0,1,6) do (
::Check if the region is available
curl -I --insecure -s -S  http://weather.wii.rc24.xyz/%%a/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK" >NUL
::And if it is (findstr returns errorlevel 0 on success), set the var to 1
if !errorlevel!==0 set region_available_%%a=1
)

goto 2_show_languages
:2_show_languages
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- Forecast Channel Configuration ---
echo.
echo Languages available for %region_name%.
echo.
echo Here is a list of languages available. Cities name will appear in the language that you will select. 
echo.
echo Choose one:
echo (If you can see more, choose a language that you understand)
echo.
echo R. Return.
echo.
if %region_available_0%==1 echo 0. Japanese
if %region_available_1%==1 echo 1. English
if %region_available_2%==1 echo 2. German
if %region_available_3%==1 echo 3. French
if %region_available_4%==1 echo 4. Spanish
if %region_available_5%==1 echo 5. Italien
if %region_available_6%==1 echo 6. Dutch
echo.
set /p language=Choose language: 
if /i %language%==r goto 1_detect_1
::If the user didn't select something between 0 and 6, ask again
if not %language% geq 0 if not %language% leq 6 goto 2_show_languages

::If the selected region is available, save the config
if !region_available_%language%!==1 goto 2_forecast_save_config

::So if the selected language is valid but just not available, also ask again
goto 2_show_languages

:2_forecast_save_config
::Save config
>"%config%\forecast_region.txt" echo %region%
>"%config%\forecast_language.txt" echo language_%language%

goto 3_news
:3_news
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- News Channel Configuration ---
echo.
echo Alright, alright, alright! I've saved Forecast Channel configuration.
echo Time for News Channel.
echo.
echo This time, it's easier. Just choose the region/language for News Channel.
echo.
echo 0. Japanese
echo 1. English (USA)
echo 2. English (Europe)
echo 3. Germany
echo 4. French
echo 5. Spanish
echo 6. Italian
echo 7. Dutch
set /p region_news=Choose: 

::If the user did select something between 0 and 7, continue on
if %region_news% geq 0 if %region_news% leq 7 goto 3_news_save_config

::Otherwise, ask again
goto 3_news

:3_news_save_config
if %region_news%==0 echo 0_Japan>"%config%\news_region.txt"
if %region_news%==1 echo 1_America>"%config%\news_region.txt"
if %region_news%==2 echo 1_Europe>"%config%\news_region.txt"
if %region_news%==3 echo 2_Europe>"%config%\news_region.txt"
if %region_news%==4 echo 3_International>"%config%\news_region.txt"
if %region_news%==5 echo 4_International>"%config%\news_region.txt"
if %region_news%==6 echo 5_Europe>"%config%\news_region.txt"
if %region_news%==7 echo 6_Europe>"%config%\news_region.txt"

goto 3_evc
:3_evc
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- Everybody Votes Channel Configuration ---
if %incorrect_region%==1 (
echo.
echo :--------------------------------------------------:
echo : Incorrect region number. Choose a correct one.   :
echo :--------------------------------------------------:
)
set incorrect_region=0
echo.
echo We're nearing to an end. Please choose a region to use with Everybody Votes Channel.
echo.
echo 016: Brazil         018: Canada         020: Chile
echo 021: Colombia       022: Costa Rica     025: Ecuador
echo 030: Guatemala      036: Mexico         040: Panama
echo 042: Peru           049: United States  052: Venezuela
echo 065: Australia      066: Austria        067: Belgium
echo 074: Denmark        076: Finland        077: France
echo 078: Germany        079: Greece         082: Ireland
echo 083: Italy          088: Luxembourg     094: Netherlands
echo 095: New Zealand    096: Norway         097: Poland
echo 098: Portugal       105: Spain          107: Sweden
echo 108: Switzerland    110: United Kingdom
echo.
set /p region=Choose your region: 
:1_detect_1_check
set region_name=NUL
if "%region%"=="016" set region_name=Brazil
if "%region%"=="018" set region_name=Canad
if "%region%"=="020" set region_name=Chile
if "%region%"=="021" set region_name=Colombia
if "%region%"=="022" set region_name=Costa Rica
if "%region%"=="025" set region_name=Ecuador
if "%region%"=="030" set region_name=Guatemala
if "%region%"=="036" set region_name=Mexico
if "%region%"=="040" set region_name=Panama
if "%region%"=="042" set region_name=Peru
if "%region%"=="049" set region_name=United States
if "%region%"=="052" set region_name=Venezuela
if "%region%"=="065" set region_name=Australia
if "%region%"=="066" set region_name=Austria
if "%region%"=="067" set region_name=Belgium 
if "%region%"=="074" set region_name=Denmark
if "%region%"=="076" set region_name=Finland
if "%region%"=="077" set region_name=France
if "%region%"=="078" set region_name=Germany
if "%region%"=="079" set region_name=Greece
if "%region%"=="082" set region_name=Ireland
if "%region%"=="083" set region_name=Italy
if "%region%"=="088" set region_name=Luxembourg
if "%region%"=="094" set region_name=Netherlands
if "%region%"=="095" set region_name=New Zealand
if "%region%"=="096" set region_name=Norway
if "%region%"=="097" set region_name=Poland
if "%region%"=="098" set region_name=Portugal
if "%region%"=="105" set region_name=Spain
if "%region%"=="107" set region_name=Sweden
if "%region%"=="108" set region_name=Switzerland
if "%region%"=="110" set region_name=United Kingdom

if "%region_name%"=="NUL" (
set incorrect_region=1
goto 3_evc
)
>"%config%\evc_country_code.txt" echo %region%
goto 3_evc_note

:3_evc_note
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Note for Everybody Votes Channel:
echo.
echo 1) Everybody Votes Channel will not work if you won't use the save file from your Wii.
echo    If you don't have a Wii, I'm sorry but there's nothing you can do unless you find a save file.
echo.
echo 2) If you need to get Everybody Votes Channel .WAD file, please run RiiConnect24 Patcher.
echo.
echo Press any key to continue.
pause>NUL
goto 4



:4
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Great^^! The configuration part is done^^!
echo.
echo Now, you'll need to choose how you want to run the program:
echo.
echo 1. Manually
echo   - You will need to run the program every time you want to download the files.
echo.
echo 2. Startup
echo   - The program will be put into startup and it will start with Windows.
echo   - The program is lightweight. Even if you have an HDD, it won't slow down your PC.
echo   - The program will run in background
echo   - It uses 0%% of your CPU and about 4-6MB of RAM.
echo   - The source code is on GitHub.
echo   - It will show Message Boxes if it encounters an error.
echo.
set /p s=Choose: 
if %s%==1 goto 4_manual
if %s%==2 goto 4_startup
goto 4

:4_manual
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
::If a previous file exists, delete it
taskkill /im VFF-Downloader-for-Dolphin.exe /f
if exist "%MainFolder%/VFF-Downloader-for-Dolphin.exe" del /q "%MainFolder%/VFF-Downloader-for-Dolphin.exe"
echo Downloading the script... please wait.
curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/VFF-Downloader-for-Dolphin.exe" --output "%MainFolder%/VFF-Downloader-for-Dolphin.exe"
goto 4_manual_2
:4_manual_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo We're done^^!
echo Now, if you want to download the files for Dolphin, there will be an option to do so in the Main Menu.
echo.
echo Come back at 10th minute of every hour - that's when scripts generate on our servers^^! ^^(For example, 8:10AM, 9:10AM, 4:10PM etc.^^)
echo.
if %rc24patcher%==0 echo Press any key to go back to main menu.
if %rc24patcher%==1 echo Press any key to go back to RiiConnect24 Patcher.
pause>NUL
if %rc24patcher%==0 goto script_start
if %rc24patcher%==1 goto:EOF
:4_startup
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Great^^!
echo If you ever want to uninstall it from startup, visit this program.
echo In the main menu, there will be an option to manage the app from the startup. You can disable it there.
echo.
echo Press any key to download and install the program to startup.
echo It will use following settings:
echo.
echo Forecast Channel region: %region_name%
echo Forecast Channel language code: %language%
echo News Channel region code: %region_news%
echo.
pause
goto 4_startup_install

:4_startup_install
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
::If a previous file exists, delete it
taskkill /im VFF-Downloader-for-Dolphin.exe /f
if exist "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" del /q "C:\Users\%user_name%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
echo Downloading the script... please wait.
::Download the new file into the startup dir
curl -f -L -s -S --insecure "%FilesHostedOn%/UPDATE/VFF-Downloader-for-Dolphin.exe" --output "C:\Users\%user_name%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
::And if curl was needed (windows 8), also copy that
if exist curl.exe copy /Y "curl.exe" "%MainFolder%"
 
goto 4_startup_done
:4_startup_done
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Done^^!
if %rc24patcher%==0 echo The background process has been started. Press any key to exit from this program.
if %rc24patcher%==1 echo Press any key to return to RiiConnect24 Patcher. The program has been started.
echo You will get a notification after the successful first setup.
start "" "C:\Users\%user_name%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" -first_start
pause>NUL
if %rc24patcher%==0 exit
if %rc24patcher%==1 GOTO:EOF
