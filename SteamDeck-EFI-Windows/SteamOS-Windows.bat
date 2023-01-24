@echo off
rem - create 1EFI-tools folder and copy the powershell script
mkdir C:\1SteamDeck-EFI
copy %~dp0custom\SteamOS-Task.ps1 C:\1SteamDeck-EFI
cls
echo SteamDeck EFI Script for Windows by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-EFI-script

rem - delete existing task and then create it
schtasks /delete /tn SteamOS-Task-donotdelete /f 2> nul
schtasks /create /tn SteamOS-Task-donotdelete /xml %~dp0custom\SteamOS-Task.xml

if %errorlevel% equ 0 goto :success
if %errorlevel% neq 0 goto :accessdenied
:accessdenied
echo Make sure you right-click the SteamOS-Windows.bat and select RUNAS ADMIN!
pause
goto :end

:success
echo Scheduled Task has been created!
echo.
echo 1. Go to Windows Administrative Tools, then Scheduled Task.
echo 2. Right-click the task called SteamOS-Task, then select Properties.
echo 3. Under the General Tab, change the option to RUN WHETHER USER IS LOGGED IN OR NOT.
echo 4. Put a check mark on DO NOT STORE PASSWORD.
echo 5. Press OK. Right click the task and select RUN.
echo 6. Go to C:\1SteamDeck-EFI and look for a file called status.txt
echo 7. Open the file and compare the SteamOS GUID and bootsequence they should be the same!
echo 8. Windows configuration is done!
pause

:end