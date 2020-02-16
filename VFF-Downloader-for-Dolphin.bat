@echo off
setlocal enableextensions
setlocal enableDelayedExpansion
cd /d "%~dp0"
:: ===========================================================================
:: .VFF File Downloader for Dolphin - main script
set version=1.0.4
:: AUTHORS: KcrPL
:: ***************************************************************************
:: Copyright (c) 2020 KcrPL, RiiConnect24 and it's (Lead) Developers
:: ===========================================================================
set last_build=2020/02/16
set at=13:51
:: Unattended mode
:: This script is meant to be running in the background.
echo Running VFF File Downloader for Dolphin...


if exist update_assistant.bat del /q update_assistant.bat
set /a alternative_curl=0
set /a first_start=0
set /a run_once=0
set /a retry=3
:: Arguments
if "%1"=="-first_start" set /a first_start=1
if "%1"=="-run_once" set /a run_once=1
:: Check for updates -> Download and put the file -> Countdown -> Repeat step 2
::
set /a Update_Activate=1
set /a offlinestorage=0
set FilesHostedOn=https://kcrpl.github.io/Patchers_Auto_Update/VFF-Downloader-for-Dolphin

set MainFolder=%appdata%\VFF-Downloader-for-Dolphin
set TempStorage=%appdata%\VFF-Downloader-for-Dolphin\internet\temp
set config=%appdata%\VFF-Downloader-for-Dolphin\config
set alternative_curl_path=%MainFolder%\curl.exe

goto check_for_update
:error_no_work_folder
echo x=MsgBox("There was an error while reading configuration files. Please run Install.bat and reconfigure the program. The program will now exit.",16,"RiiConnect24 .VFF Downloader for Dolphin")>"%appdata%\warning.vbs"
start "" "%appdata%\warning.vbs"
del "%config%\warning.vbs"
exit
:check_for_update
:: For whatever reason, it returns 2
echo.
curl
if not %errorlevel%==2 set /a alternative_curl=1


echo --- [%time:~0,8%] First update check ---

:: Update script.
set updateversion=0.0.0
:: Delete version.txt and whatsnew.txt
if %offlinestorage%==0 if exist "%TempStorage%\version.txt" del "%TempStorage%\version.txt" /q
if %offlinestorage%==0 if exist "%TempStorage%\whatsnew.txt" del "%TempStorage%\whatsnew.txt" /q

if not exist "%TempStorage%" goto error_no_work_folder
:: Commands to download files from server.

if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==0 call curl -s -S --insecure "%FilesHostedOn%/UPDATE/whatsnew_vff_downloader.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==0 call curl -s -S --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==1 call %alternative_curl_path% -s -S --insecure "%FilesHostedOn%/UPDATE/whatsnew_vff_downloader.txt" --output "%TempStorage%\whatsnew.txt"
if %Update_Activate%==1 if %offlinestorage%==0 if %alternative_curl%==1 call %alternative_curl_path% -s -S --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
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
if %alternative_curl%==0 curl -s -S --insecure "https://kcrPL.github.io/Patchers_Auto_Update/RiiConnect24Patcher/UPDATE/update_assistant.bat" --output "update_assistant.bat"
if %alternative_curl%==1 %alternative_curl_path% -s -S --insecure "https://kcrPL.github.io/Patchers_Auto_Update/RiiConnect24Patcher/UPDATE/update_assistant.bat" --output "update_assistant.bat"
	set temperrorlev=%errorlevel%
	if not %temperrorlev%==0 goto error_updating
start "" update_assistant.bat -VFF_Downloader_Main_Exec
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
echo --- [%time:~0,8%] Reading configuration ---
if not exist "%config%\forecast_region.txt" goto error_config
if not exist "%config%\forecast_language.txt" goto error_config
if not exist "%config%\news_region.txt" goto error_config



set /p forecast_region=<"%config%\forecast_region.txt"
set /p templanguage=<"%config%\forecast_language.txt"
set forecast_language=%templanguage:~9,1%
set /p news_region=<"%config%\news_region.txt"

set /p dolphin_installation=<"%config%\path_to_install.txt"
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
echo --- [%time:~0,8%] Cleaning old files [Forecast Channel] ---
echo.
::Clean forecast channel data
if exist "%dolphin_installation%\48414645\data\wc24dl.vff" del /q %dolphin_installation%\48414645\data\wc24dl.vff"
if exist "%dolphin_installation%\4841464a\data\wc24dl.vff" del /q %dolphin_installation%\4841464a\data\wc24dl.vff"
if exist "%dolphin_installation%\48414650\data\wc24dl.vff" del /q %dolphin_installation%\48414650\data\wc24dl.vff"
echo.
echo --- [%time:~0,8%] Cleaning old files [News Channel] ---
echo.
::Clean news channel data
if exist "%dolphin_installation%\48414745\data\wc24dl.vff" del /q %dolphin_installation%\48414745\data\wc24dl.vff"
if exist "%dolphin_installation%\4841474a\data\wc24dl.vff" del /q %dolphin_installation%\4841474a\data\wc24dl.vff"
if exist "%dolphin_installation%\48414750\data\wc24dl.vff" del /q %dolphin_installation%\48414750\data\wc24dl.vff"
echo.
echo --- [%time:~0,8%] Downloading files ---
::Forecast
if %alternative_curl%==0 curl -s -S --insecure "http://weather.wii.rc24.xyz/%forecast_language%/%forecast_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_forecast.vff"
if %alternative_curl%==1 %alternative_curl_path% -s -S --insecure "http://weather.wii.rc24.xyz/%forecast_language%/%forecast_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_forecast.vff"
echo Done: 1/2
::News
if %alternative_curl%==0 curl -s -S --insecure "http://news.wii.rc24.xyz/v2/%news_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_news.vff"
if %alternative_curl%==1 %alternative_curl_path% -s -S --insecure "http://news.wii.rc24.xyz/v2/%news_region%/wc24dl.vff" --output "%dolphin_installation%\wc24dl_news.vff"
echo Done: 2/2

if not exist "%dolphin_installation%\48414645\data" md "%dolphin_installation%\48414645\data"
if not exist "%dolphin_installation%\4841464a\data" md "%dolphin_installation%\4841464a\data"
if not exist "%dolphin_installation%\48414650\data" md "%dolphin_installation%\48414650\data"
if not exist "%dolphin_installation%\48414745\data" md "%dolphin_installation%\48414745\data"
if not exist "%dolphin_installation%\4841474a\data" md "%dolphin_installation%\4841474a\data"
if not exist "%dolphin_installation%\48414750\data" md "%dolphin_installation%\48414750\data"

echo --- [%time:~0,8%] Copying files into directory ---
copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\48414645\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\4841464a\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

copy "%dolphin_installation%\wc24dl_forecast.vff" "%dolphin_installation%\48414650\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\48414745\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\4841474a\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

copy "%dolphin_installation%\wc24dl_news.vff" "%dolphin_installation%\48414750\data\wc24dl.vff"
set /a temperrorlev=%errorlevel%
if not %temperrorlev%==0 goto error_cannot_copy

echo --- [%time:~0,8%] Delete temporary files ---
del /q "%dolphin_installation%\wc24dl_news.vff"
del /q "%dolphin_installation%\wc24dl_forecast.vff"

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

echo --- [%time:~0,8%] Waiting 600 seconds (10 minutes) ---
call "%windir%\system32\timeout.exe" 600 /nobreak >NUL

echo --- [%time:~0,8%] Checking for update ---
::Check for update
if %alternative_curl%==0 call curl -s -S --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if %alternative_curl%==1 call %alternative_curl_path% -s -S --insecure "%FilesHostedOn%/UPDATE/version_vff_downloader.txt" --output "%TempStorage%\version.txt"
if exist "%TempStorage%\version.txt" set /p updateversion=<"%TempStorage%\version.txt"
if not %updateversion%==%version% goto run_update
echo --- Done checking for update [%time:~0,8%] ---

goto count_time

