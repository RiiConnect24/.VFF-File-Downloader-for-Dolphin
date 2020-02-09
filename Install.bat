@echo off
setlocal enableextensions
setlocal enableDelayedExpansion
cd /d "%~dp0"
echo 	Starting up...
echo	The program is starting...
:: ===========================================================================
:: .VFF File Downloader for Dolphin
set version=1.0.1
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


:: Window Title
title .VFF File Downloader for Dolphin v%version% Created by @KcrPL

set last_build=2020/02/09
set at=04:50
:: ### Auto Update ###	
:: 1=Enable 0=Disable
:: Update_Activate - If disabled, patcher will not even check for updates, default=1
:: offlinestorage - Only used while testing of Update function, default=0
:: FilesHostedOn - The website and path to where the files are hosted. WARNING! DON'T END WITH "/"
:: MainFolder/TempStorage - folder that is used to keep version.txt and whatsnew.txt. These two files are deleted every startup but if offlinestorage will be set 1, they won't be deleted.
set /a Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://kcrpl.github.io/Patchers_Auto_Update/VFF-Downloader-for-Dolphin

set MainFolder=%appdata%\VFF-Downloader-for-Dolphin
set TempStorage=%appdata%\VFF-Downloader-for-Dolphin\internet\temp
set config=%appdata%\VFF-Downloader-for-Dolphin\config

set header=.VFF File Downloader - (C) KcrPL v%version% (Compiled on %last_build% at %at%)

if not exist "%MainFolder%" md "%MainFolder%"
if not exist "%TempStorage%" md "%TempStorage%"
if not exist "%config%" md "%config%"
:: Load background color from file if it exists
for /f "usebackq" %%a in ("%appdata%\RiiConnect24Patcher\internet\temp\background_color.txt") do color %%a
goto begin_main
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
if exist "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" echo             smmmmm`+mMMMMMMMMMNhMNNMNNMMMMMMMMMMMMMMy   4. Manage startup VFF Downloader
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
echo 2. Delete VFF Downloader for Dolphin from startup
echo 3. If VFF Downloader is running, shut it down.
set /p s=Choose: 
if %s%==r goto begin_main
if %s%==R goto begin_main
if %s%==1 goto settings_del_config
if %s%==2 goto settings_del_vff_downloader
if %s%==3 goto settings_taskkill

:settings_del_config
rmdir /s /q "%appdata%\VFF-Downloader-for-Dolphin"
taskkill /im VFF-Downloader-for-Dolphin.exe /f
 
del /q "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
echo Done^^!
pause
goto settings
:settings_del_vff_downloader
taskkill /im VFF-Downloader-for-Dolphin.exe /f
del /q "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"

echo Done^^!
pause
goto settings
:settings_taskkill
taskkill /im VFF-Downloader-for-Dolphin.exe /f
echo Done^^!
pause
goto settings


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
call powershell -command (new-object System.Net.WebClient).DownloadFile('"%FilesHostedOn%/curl.exe"', '"curl.exe"')
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto begin_main_download_curl_error

goto begin_main1
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
:: For whatever reason, it returns 2
curl
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

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q

if not exist "%TempStorage%" md "%TempStorage%"
:: Commands to download files from server.

if %Update_Activate%==1 if %offlinestorage%==0 call curl -s -S --insecure "%FilesHostedOn%/UPDATE/whatsnew.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %offlinestorage%==0 call curl -s -S --insecure "%FilesHostedOn%/UPDATE/version.txt" --output "%TempStorage%\version.txt"
	set /a temperrorlev=%errorlevel%
	
set /a updateserver=1
	::Bind exit codes to errors here
	if "%temperrorlev%"=="6" goto no_internet_connection
	if not %temperrorlev%==0 set /a updateserver=0

if exist "%TempStorage%\version.txt`" ren "%TempStorage%\version.txt`" "version.txt"
if exist "%TempStorage%\whatsnew.txt`" ren "%TempStorage%\whatsnew.txt`" "whatsnew.txt"
:: Copy the content of version.txt to variable.
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not exist "%TempStorage%\version.txt" set /a updateavailable=0
if %Update_Activate%==1 if exist "%TempStorage%\version.txt" set /a updateavailable=1
:: If version.txt doesn't match the version variable stored in this batch file, it means that update is available.
if %updateversion%==%version% set /a updateavailable=0

if exist "%TempStorage%\annoucement.txt" del /q "%TempStorage%\annoucement.txt"
curl -s -S --insecure "%FilesHostedOn%/UPDATE/annoucement.txt" --output %TempStorage%\annoucement.txt"

if %Update_Activate%==1 if %updateavailable%==1 set /a updateserver=2
if %Update_Activate%==1 if %updateavailable%==1 goto update_notice

goto 1
:update_notice
if exist "%MainFolder%\failsafe.txt" del /q "%MainFolder%\failsafe.txt"
if %updateversion%==0.0.0 goto error_update_not_available
set /a update=1
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
echo    /---\   An Update is available.              
echo   /     \  An Update for this program is available. We suggest updating the VFF Downloader to the latest version.
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
if %s%==3 goto whatsnew
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
curl -s -S --insecure "https://KcrPL.github.io/Patchers_Auto_Update/RiiConnect24Patcher/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	set temperrorlev=%errorlevel%
	if not %temperrorlev%==0 goto error_updating
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
if not exist %TempStorage%\whatsnew.txt goto whatsnew_notexist
echo %header%
echo ------------------------------------------------------------------------------------------------------------------------------
echo.
echo What's new in update %updateversion%?
echo.
type "%TempStorage%\whatsnew.txt"
pause>NUL
goto update_notice
:whatsnew_notexist
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Error. What's new file is not available.
echo.
echo Press any button to go back.
pause>NUL
goto update_notice
:1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Welcome to the installation process of RiiConnect24 VFF Downloader for Dolphin!
echo This program will allow you to use Forecast/News Channel on your Dolphin without the NEWS00006 error.
echo.
echo First, we need to detect your Dolphin user files.
echo.
echo 1. Continue
echo 2. Exit
set /p s=Choose: 
if %s%==1 goto 1_detect
if %s%==2 goto begin_main
goto 1
:1_detect
set /a detected=0

FOR /F "tokens=2* skip=2" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Personal"') do set Documents_Folder=%%b

set userprofile=
set /a fix_detect=0
echo %Documents_Folder% | findstr "%USERPROFILE% && set /a fix_detect=1

if %fix_detect%==1 if exist "%Documents_Folder%\Dolphin Emulator\Wii\title\00010002" set /a detected=1
if %fix_detect%==0 if exist "C:\Users\%username%\Documents\Dolphin Emulator\Wii\title\00010002" set /a detected=1

if %detected%==1 if %fix_detect%==1 echo %Documents_Folder%\Dolphin Emulator\Wii\title\00010002> "%config%\path_to_install.txt"
if %detected%==1 if %fix_detect%==0 echo C:\Users\%username%\Documents\Dolphin Emulator\Wii\title\00010002> "%config%\path_to_install.txt"
goto 1_detect_%detected%

:1_detect_0
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
echo 3. Exit
set /p s=Choose:
if %s%==1 goto 1_detect
if %s%==2 goto 1_detect_set
if %s%==3 goto 1 
goto 1_detect_0
:1_detect_set
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Could not find folder with Wii NAND used for Dolphin.
echo.
echo Default location: C:\Users\%username%\Documents\Dolphin Emulator\Wii\title\00010002
echo Make sure that the format of the location (folder structure) will remain the same, otherwise things will break.
echo.
set /p dolphin_location=Your location: 
echo %dolphin_location%> "%config%\path_to_install.txt"
goto 1_detect_1
:1_detect_1
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo --- Forecast Channel Configuration ---
echo.
echo Success^^! I've detected the path successfully and saved it... for later :)
if %incorrect_region%==1 echo :--------------------------------------------------:
if %incorrect_region%==1 echo : Incorrect region number. Choose correct one.     :
if %incorrect_region%==1 echo :--------------------------------------------------:
set /a incorrect_region=0
echo Now, you need to choose your region to use with Forecast Channel from the list below.
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
goto 1_detect_1_check
:1_detect_1_check
set region_name=NUL

if "%region%"=="001" set region_name=Japan
if "%region%"=="008" set region_name=Anguilla
if "%region%"=="009" set region_name=Antigua and Barbuda
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

if "%region_name%"=="NUL" set /a incorrect_region=1&goto 1_detect_1

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

set /a region_available_0_Japanese=0
set /a region_available_1_English=0
set /a region_available_2_German=0
set /a region_available_3_French=0
set /a region_available_4_Spanish=0
set /a region_available_5_Italian=0
set /a region_available_6_Dutch=0

curl -I --insecure -s -S  http://weather.wii.rc24.xyz/0/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK" >NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_0_Japanese=1

curl -I --insecure -s -S  http://weather.wii.rc24.xyz/1/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK" >NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_1_English=1


curl -I --insecure -s -S  http://weather.wii.rc24.xyz/2/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK" >NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_2_German=1

curl -I --insecure -s -S  http://weather.wii.rc24.xyz/3/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK">NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_3_French=1

curl -I --insecure -s -S  http://weather.wii.rc24.xyz/4/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK">NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_4_Spanish=1

curl -I --insecure -s -S  http://weather.wii.rc24.xyz/5/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK">NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_5_Italian=1

curl -I --insecure -s -S http://weather.wii.rc24.xyz/6/%region%/wc24dl.vff | findstr "HTTP/1.1" | findstr "200 OK">NUL
set /a temperrorlev=%errorlevel%
if %temperrorlev%==0 set /a region_available_6_Dutch=1

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
echo Here is a list of languages available. Choose one:
echo (If you can see more, choose a language that you understand)
echo.
echo R. Return.
echo.
if %region_available_0_Japanese%==1 echo 0. Japanese
if %region_available_1_English%==1 echo 1. English
if %region_available_2_German%==1 echo 2. German
if %region_available_3_French%==1 echo 3. French
if %region_available_4_Spanish%==1 echo 4. Spanish
if %region_available_5_Italian%==1 echo 5. Italien
if %region_available_6_Dutch%==1 echo 6. Dutch
echo.
set /p language=Choose language: 
if %language%==r goto 1_detect_1
if %language%==R goto 1_detect_1

if %language%==0 if %region_available_0_Japanese%==1 goto 2_forecast_save_config
if %language%==1 if %region_available_1_English%==1 goto 2_forecast_save_config
if %language%==2 if %region_available_2_German%==1 goto 2_forecast_save_config
if %language%==3 if %region_available_3_French%==1 goto 2_forecast_save_config
if %language%==4 if %region_available_4_Spanish%==1 goto 2_forecast_save_config
if %language%==5 if %region_available_5_Italian%==1 goto 2_forecast_save_config
if %language%==6 if %region_available_6_Dutch%==1 goto 2_forecast_save_config

goto 2_show_languages

:2_forecast_save_config
::Save config
echo %region%>%config%\forecast_region.txt
echo language_%language%>%config%\forecast_language.txt


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

if %region_news%==0 goto 3_news_save_config
if %region_news%==1 goto 3_news_save_config
if %region_news%==2 goto 3_news_save_config
if %region_news%==3 goto 3_news_save_config
if %region_news%==4 goto 3_news_save_config
if %region_news%==5 goto 3_news_save_config
if %region_news%==6 goto 3_news_save_config
if %region_news%==7 goto 3_news_save_config

goto 3_news
:3_news_save_config
if %region_news%==0 echo 0_Japan>%config%\news_region.txt
if %region_news%==1 echo 1_America>%config%\news_region.txt
if %region_news%==2 echo 1_Europe>%config%\news_region.txt
if %region_news%==3 echo 2_Europe>%config%\news_region.txt
if %region_news%==4 echo 3_International>%config%\news_region.txt
if %region_news%==5 echo 4_International>%config%\news_region.txt
if %region_news%==6 echo 5_Europe>%config%\news_region.txt
if %region_news%==7 echo 6_Europe>%config%\news_region.txt

goto 4
:4
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Great^^! The configuration part is done^^!
echo.
echo Now, how are you gonna run the program?
echo.
echo 1. Manually
echo   - You will need to run the program every time you want to download the files.
echo.
echo 2. Startup
echo   - The program will be put into startup and it will start with Windows.
echo   - The program is lightweight. Even if you have an HDD, it won't slow your PC.
echo   - The program will run in background
echo   - It uses 0% of your CPU and about 4-6MB of RAM.
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
if exist "%MainFolder%/UPDATE/VFF-Downloader-for-Dolphin.exe" del /q "%MainFolder%/VFF-Downloader-for-Dolphin.exe"
echo Downloading the script... please wait.
curl -s -S --insecure "https://kcrpl.github.io/Patchers_Auto_Update/VFF-Downloader-for-Dolphin/UPDATE/VFF-Downloader-for-Dolphin.exe" --output "%MainFolder%/VFF-Downloader-for-Dolphin.exe"
goto 4_manual_2
:4_manual_2
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo We're done^^!
echo Now, if you want to download the files for Dolphin, there will be an option to do so in the Main Menu.
echo.
echo Come back at 10th of every hour - that's when scripts generate on our servers! (For example, 8:10AM, 9:10AM, 4:10PM etc.)
echo.
echo Press any key to go back to main menu.
pause>NUL
goto script_start
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
if exist "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" del /q "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
echo Downloading the script... please wait.
curl -s -S --insecure "https://kcrpl.github.io/Patchers_Auto_Update/VFF-Downloader-for-Dolphin/UPDATE/VFF-Downloader-for-Dolphin.exe" --output "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe"
if exist curl.exe copy /Y "curl.exe" "%MainFolder%"
 
goto 4_startup_done
:4_startup_done
cls
echo %header%
echo -----------------------------------------------------------------------------------------------------------------------------
echo.
echo Done^^!
echo Press any key to shut down this program and to start the background process. 
echo You will get a notification after the successful first setup.
start "" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\VFF-Downloader-for-Dolphin.exe" -first_start
exit














