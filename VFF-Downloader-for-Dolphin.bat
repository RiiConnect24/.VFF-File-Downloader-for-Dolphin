@echo off
setlocal enableextensions
setlocal enableDelayedExpansion
cd /d "%~dp0"
:: ===========================================================================
:: .VFF File Downloader for Dolphin - main script
set version=1.1.0
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020-2022 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================
set last_build=2022/02/19
set at=23:59
:: Unattended mode
:: This script is meant to be running in the background.
if exist update_assistant.bat del /q update_assistant.bat
if exist VFF-Downloader-for-DolphinTEMP.exe (
	taskkill /im VFF-Downloader-for-DolphinTEMP.exe /f
	del /q VFF-Downloader-for-DolphinTEMP.exe
)

:: Whoops
if exist "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Install.bat" del /q "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Install.bat"

echo Running VFF File Downloader for Dolphin...


if exist update_assistant.bat del /q update_assistant.bat
set /a alternative_curl=0
set /a first_start=0
set /a run_once=0
set /a retry=3

set header=.VFF File Downloader for Dolphin - (C) KcrPL v%version% (Compiled on %last_build% at %at%)


:: Arguments
if "%1"=="-first_start" set /a first_start=1
if "%1"=="-run_once" set /a run_once=1
:: Check for updates -> Download and put the file -> Countdown -> Repeat step 2
::
set /a Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://patcher.rc24.xyz/update/VFF-Downloader-for-Dolphin/v1

set MainFolder=%appdata%\VFF-Downloader-for-Dolphin
set TempStorage=%appdata%\VFF-Downloader-for-Dolphin\internet\temp
set config=%appdata%\VFF-Downloader-for-Dolphin\config
set alternative_curl_path=%MainFolder%\curl.exe

cls
echo %header%
echo ---------------------------------------------------------------------------------------
echo.

goto startup_wait

:startup_wait
if %run_once%==1 goto check_for_update
echo --- [%date%] [%time:~0,8%] The program is probably sitting in the background as startup. 
echo                Waiting 30 seconds to free CPU resources and continuing. 
echo                If you can see this, pressing any key will skip the 30 seconds wait time.
call "%windir%\system32\timeout.exe" 30 >NUL

goto check_for_internet

:no_internet_wait
echo --- [%date%] [%time:~0,8%] Error while checking for internet connection - waiting 3 minutes and trying again ---
call "%windir%\system32\timeout.exe" 180>NUL

goto check_for_internet
:check_for_internet
echo --- [%date%] [%time:~0,8%] Checking for Internet connection... ---
curl -s http://www.msftncsi.com/ncsi.txt>NUL
if not %errorlevel%==0 goto no_internet_wait
echo                .
echo                .
echo                .: OK^^!
call :check_rc24_connection
	if %errorlevel%==1 goto server_dead
goto check_for_update
:check_rc24_connection
echo.
echo --- [%date%] [%time:~0,8%] Checking connection to RiiConnect24... ---
For /F "Delims=" %%A In ('call curl -f -L -s --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "https://patcher.rc24.xyz/connection_test.txt"') do set "connection_test=%%A"

	if not "%connection_test%"=="OK" exit /b 1

set ip_to_ping=patcher.rc24.xyz
for /F "tokens=1-9 delims==< " %%a in ('PING -n 1 -w 2500 %ip_to_ping%') do if "%%h"=="TTL" set network_latency=%%g
echo                .
echo                .
echo                .: OK^^! (%network_latency%)

exit /b 0

:server_dead
echo                .
echo                .
echo                .: Error^^! RiiConnect24 is currently under maintenance or unavailable.
echo                          Continuing to try, please be patient.
echo                          Check https://status.rc24.xyz for details.
echo.
echo --- [%date%] [%time:~0,8%] Waiting 180 seconds (3 minutes) ---
call "%windir%\system32\timeout.exe" 180 >NUL
goto check_for_internet


:error_no_work_folder
echo x=MsgBox("There was an error while reading configuration files. Please run Install.bat and reconfigure the program. The program will now exit.",16,"RiiConnect24 .VFF Downloader for Dolphin")>"%appdata%\warning.vbs"
start "" "%appdata%\warning.vbs"
del "%config%\warning.vbs"
exit
:check_for_update
echo.
curl -s ""
if not %errorlevel%==3 set /a alternative_curl=1


echo --- [%date%] [%time:~0,8%] First update check ---

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q

if not exist "%TempStorage%" goto error_no_work_folder
:: Commands to download files from server.
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==0 call curl -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/whatsnew_vff_downloader.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==0 call curl -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==1 call %alternative_curl_path% -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/whatsnew_vff_downloader.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==1 call %alternative_curl_path% -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
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

if %Update_Activate%==1 if %updateavailable%==1 set /a updateserver=2
if %Update_Activate%==1 if %updateavailable%==1 goto run_update

goto read_config
:run_update

if %alternative_curl%==0 curl -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1/UPDATE/update_assistant.bat" --output "update_assistant.bat"
if %alternative_curl%==1 %alternative_curl_path% -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	set temperrorlev=%errorlevel%
	if not %temperrorlev%==0 goto error_updating
if "%run_once%"=="0" start "" update_assistant.bat -VFF_Downloader_Main_Exec
if "%run_once%"=="1" start "" update_assistant.bat -VFF_Downloader_Main_Exec -run_once
exit
:error_updating
::echo [%date%] [%time:~0,5%] ERROR: Updating failed with exit code: %temperrorlev%>>"%MainFolder%\log.txt"
goto read_config

:error_cannot_copy

if not %retry%==0 set /a retry=%retry%-1
if /i %retry% GTR 0 goto download_files

echo x=MsgBox("There was an error while copying files. This may happen due to incorrect configuration. Please run Install.bat and reconfigure the program. The program will now exit. Error code - %temperrorlev%",16,"RiiConnect24 .VFF Downloader for Dolphin")>"%appdata%\warning.vbs"
start "" "%appdata%\warning.vbs"
del "%config%\warning.vbs"
exit

:read_config
echo --- [%date%] [%time:~0,8%] Reading configuration ---
if not exist "%config%\forecast_region.txt" goto error_config
if not exist "%config%\forecast_language.txt" goto error_config
if not exist "%config%\news_region.txt" goto error_config

	if not exist "%config%\evc_country_code.txt" >"%config%\evc_country_code.txt" echo 0

set /p forecast_region=<"%config%\forecast_region.txt"
set /p templanguage=<"%config%\forecast_language.txt"
set forecast_language=%templanguage:~9,1%
set /p news_region=<"%config%\news_region.txt"
set /p evc_country_code=<"%config%\evc_country_code.txt"

set /p dolphin_installation=<"%config%\path_to_install.txt".
goto download_files

:waiting_for_internet
echo No internet connection/could not connect to remote host.
timeout 360 /nobreak >NUL
goto download_files

:error_curl_shutdown

if not %retry%==0 set /a retry=%retry%-1
if /i %retry% GTR 0 goto download_files

echo x=MsgBox("There was an error while downloading files. The program will now exit. Error code - %temperrorlev%",16,"RiiConnect24 .VFF Downloader for Dolphin")>"%appdata%\warning.vbs"
start "" "%appdata%\warning.vbs"
del "%config%\warning.vbs"
exit


:download_files

call :check_rc24_connection
	if %errorlevel%==1 goto server_dead
echo.
echo --- [%date%] [%time:~0,8%] Cleaning old files [Forecast Channel] ---
::Clean forecast channel data
if exist "%dolphin_installation%\48414645\data\wc24dl.vff" del /q "%dolphin_installation%\48414645\data\wc24dl.vff"
if exist "%dolphin_installation%\4841464a\data\wc24dl.vff" del /q "%dolphin_installation%\4841464a\data\wc24dl.vff"
if exist "%dolphin_installation%\48414650\data\wc24dl.vff" del /q "%dolphin_installation%\48414650\data\wc24dl.vff"
echo --- [%date%] [%time:~0,8%] Cleaning old files [News Channel] ---
::Clean news channel data
if exist "%dolphin_installation%\48414745\data\wc24dl.vff" del /q "%dolphin_installation%\48414745\data\wc24dl.vff"
if exist "%dolphin_installation%\4841474a\data\wc24dl.vff" del /q "%dolphin_installation%\4841474a\data\wc24dl.vff"
if exist "%dolphin_installation%\48414750\data\wc24dl.vff" del /q "%dolphin_installation%\48414750\data\wc24dl.vff"


echo --- [%date%] [%time:~0,8%] Cleaning old files [Everybody Votes Channel] ---
::Clean EVC data
if exist "%dolphin_installation%\..\00010001\48414a45\data\wc24dl.vff" del /q "%dolphin_installation%\..\00010001\48414a45\data\wc24dl.vff"
if exist "%dolphin_installation%\..\00010001\48414a50\data\wc24dl.vff" del /q "%dolphin_installation%\..\00010001\48414a50\data\wc24dl.vff"
if exist "%dolphin_installation%\..\00010001\48414a4a\data\wc24dl.vff" del /q "%dolphin_installation%\..\00010001\48414a4a\data\wc24dl.vff"
echo.
echo --- [%date%] [%time:~0,8%] Downloading files ---
::Forecast
:: Sending debug info from now on
if %alternative_curl%==0 curl -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %forecast_region% / %forecast_language%" --insecure "http://weather.wii.rc24.xyz/%forecast_language%/%forecast_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_forecast.vff"
if %alternative_curl%==1 %alternative_curl_path% -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %forecast_region% / %forecast_language%" --insecure "http://weather.wii.rc24.xyz/%forecast_language%/%forecast_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_forecast.vff"
echo Done: 1/3 ^| Forecast Channel
::News
if %alternative_curl%==0 curl -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %news_region%" --insecure "http://news.wii.rc24.xyz/v2/%news_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_news.vff"
if %alternative_curl%==1 %alternative_curl_path% -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %news_region%" --insecure "http://news.wii.rc24.xyz/v2/%news_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_news.vff"
echo Done: 2/3 ^| News Channel
::EVC
if not "%evc_country_code%"=="0" if not "%evc_country_code%"=="1" if %alternative_curl%==0 curl -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %evc_country_code%" --insecure "http://vt.wii.rc24.xyz/%evc_country_code%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_evc.vff"
if not "%evc_country_code%"=="0" if not "%evc_country_code%"=="1" if %alternative_curl%==1 %alternative_curl_path% -s -S -L --user-agent "VFF-Downloader-for-Dolphin v%version% / %evc_country_code%" --insecure "http://vt.wii.rc24.xyz/%evc_country_code%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_evc.vff"
if "%evc_country_code%"=="0" echo          .. EVC Skipping
if "%evc_country_code%"=="1" echo          .. EVC Skipping
if not "%evc_country_code%"=="0" if not "%evc_country_code%"=="1" echo Done: 3/3 ^| Everybody Votes Channel


if not exist "%dolphin_installation%\48414645\data" md "%dolphin_installation%\48414645\data"
if not exist "%dolphin_installation%\4841464a\data" md "%dolphin_installation%\4841464a\data"
if not exist "%dolphin_installation%\48414650\data" md "%dolphin_installation%\48414650\data"
if not exist "%dolphin_installation%\48414745\data" md "%dolphin_installation%\48414745\data"
if not exist "%dolphin_installation%\4841474a\data" md "%dolphin_installation%\4841474a\data"
if not exist "%dolphin_installation%\48414750\data" md "%dolphin_installation%\48414750\data"
if not exist "%dolphin_installation%\..\00010001\48414a45\data" md "%dolphin_installation%\..\00010001\48414a45\data"
if not exist "%dolphin_installation%\..\00010001\48414a50\data" md "%dolphin_installation%\..\00010001\48414a50\data"
if not exist "%dolphin_installation%\..\00010001\48414a4a\data" md "%dolphin_installation%\..\00010001\48414a4a\data"

echo.
echo --- [%date%] [%time:~0,8%] Copying files into directory --- 
copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\48414645\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 1st file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\4841464a\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 2nd file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\48414650\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 3rd file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\48414745\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 4th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\4841474a\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 5th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\48414750\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 6th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

if not %evc_country_code%==0 if not %evc_country_code%==1 copy "%dolphin_installation%\wc24dl_evc.vff" "%dolphin_installation%\..\00010001\48414a45\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 7th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

if not %evc_country_code%==0 if not %evc_country_code%==1 copy "%dolphin_installation%\wc24dl_evc.vff" "%dolphin_installation%\..\00010001\48414a50\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 8th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait

if not %evc_country_code%==0 if not %evc_country_code%==1 copy "%dolphin_installation%\wc24dl_evc.vff" "%dolphin_installation%\..\00010001\48414a4a\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 echo --- [%date%] [%time:~0,8%] DEBUG: 9th file copy fail - waiting and trying later ---
if not %temperrorlev%==0 goto error_wait


echo --- [%date%] [%time:~0,8%] Delete temporary files ---
del /q "%dolphin_installation%\wc24dl_news.vff"
del /q "%dolphin_installation%\wc24dl_forecast.vff"
if not %evc_country_code%==0 if not %evc_country_code%==1 del /q "%dolphin_installation%\wc24dl_evc.vff"

if %first_start%==1 echo x=MsgBox("First configuration is done. Please run Dolphin and check for yourself :)",64,"RiiConnect24 .VFF Downloader for Dolphin")>"%appdata%\warning.vbs"
if %first_start%==1 start "" "%appdata%\warning.vbs"
if %first_start%==1 set /a first_start=0

set last_hour_download=%time:~0,2%
set /a already_checked_this_hour=1

if %run_once%==1 echo x=MsgBox("Done successfully - the program will now exit.",64,"RiiConnect24 .VFF Downloader for Dolphin"^)>"%appdata%\warning.vbs"
if %run_once%==1 start "" "%appdata%\warning.vbs"
if %run_once%==1 exit

::Reset retry counter
title %retry%
set /a retry=3

goto count_time

:count_time
if not "%last_hour_download%"=="%time:~0,2%" set /a already_checked_this_hour=0
if %already_checked_this_hour%==0 if /i "%time:~3,2%" GEQ "10" goto download_files

echo --- [%date%] [%time:~0,8%] Waiting 600 seconds (10 minutes) ---
call "%windir%\system32\timeout.exe" 600 /nobreak >NUL

echo --- [%date%] [%time:~0,8%] Checking for update ---
::Check for update
if %alternative_curl%==0 call curl -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if %alternative_curl%==1 call %alternative_curl_path% -s -S --user-agent "VFF-Downloader-for-Dolphin v%version%" --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not %updateversion%==%version% goto run_update
echo --- [%date%] [%time:~0,8%] Done checking for update ---

goto count_time
:error_wait
echo --- [%date%] [%time:~0,8%] Waiting 180 seconds (3 minutes) ---
call "%windir%\system32\timeout.exe" 180 /nobreak >NUL
goto download_files