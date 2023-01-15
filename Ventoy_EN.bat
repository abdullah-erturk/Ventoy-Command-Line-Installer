
:: INFO:

:: GRUB2 FILE MANAGER SETUP & DOWNLOAD SUITE
:: Copyright (C) 2020  mephistooo2 | TNCTR.com
:: Grub2 File Manager USB Installer Github: https://github.com/abdullah-erturk/SecureBoot-Grub2FM-Suite

:: Ventoy Command Line Installer 
:: Copyright (C) 2020  mephistooo2 | TNCTR.com
:: https://github.com/abdullah-erturk/Ventoy-Command-Line-Installer

:: Ventoy & Grub2FM Multiboot (With Original Files)
:: Copyright (C) 2020  mephistooo2 | TNCTR.com
:: Ventoy & Grub2FM Multiboot (With Original Files) Github: https://github.com/abdullah-erturk/Ventoy-Grub2FM-Multiboot-With-Original-Files

:: Ventoy Github: https://github.com/ventoy/Ventoy
:: credit: longpanda
::===============================================================================================================
@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
for /f "delims=" %%x in (Ventoy\version) do set ver=%%x >nul 2>&1
::===============================================================================================================
:MAINMENU
setlocal enableextensions disabledelayedexpansion
for /f "tokens=6 delims=[]. " %%# in ('ver') do set winbuild=%%#
del %temp%\msg.vbs /f /q >nul 2>&1
echo Set WshShell = CreateObject("WScript.Shell"^) >> %temp%\msg.vbs
echo x = WshShell.Popup ("The Operating System is not Windows 10. The script file only runs on Windows 10. The process will be terminated in 5 seconds.",5, "..:: WARNING ::..") >> %temp%\msg.vbs
if %winbuild% LSS 10240 (
call %temp%\msg.vbs
del %temp%\msg.vbs /f /q >nul 2>&1
exit
)
::===============================================================================================================
mode con:cols=85 lines=45
title Ventoy MultiBoot Suite v%ver% - script made by mephistooo2 ^| TNCTR.com
:Main
cls
echo.
echo =====================================================================================
echo.
echo	  Ventoy MultiBoot Suite v%ver% - script made by mephistooo2 ^| TNCTR.com
echo.
echo	 	  1 - INSTALL VENTOY USB/HDD DISK
echo.
echo	 	  2 - VENTOY UPDATE
echo.
echo	 	  3 - VENTOY VISIT WEBSITE
echo.
echo	 	  4 - EXIT
echo.
echo =====================================================================================
echo.
choice /c 1234 /cs /n /m "YOUR CHOICE : "
echo.
if errorlevel 4 Exit
if errorlevel 3 goto :TNCTR
if errorlevel 2 goto :Update
if errorlevel 1 goto :Ventoy
echo.
::===============================================================================================================
:Ventoy
	call :MsgBox "If an error occurs in the Ventoy Command Line installation, error warnings will not appear. \n \nTherefore, if you encounter an error, review the Ventoy log files. "  "VBInformation" "..:: WARNING ::.."
	echo.   [N]on-Destructive Installation       [F]ormatted Installation
	echo.
	set dest=0
	choice /C:NF /N /M "How would you like the Ventoy setup to be? : "
	if errorlevel 2 goto :Destructive
	if errorlevel 1 set dest=1
	if errorlevel 1 goto :Non-Destructive 
::===============================================================================================================
:Destructive
	echo.
	set style=
	echo.   [G]PT       [M]BR 
	echo.
	choice /C:GM /N /M "Select the disk structure to install Ventoy : "
	if errorlevel 1 set style=GPT
	if errorlevel 2 set style=MBR
	echo.
	
	set diskstr=
	echo.   [1] NTFS       [2] FAT32       [3] exFAT       [4] UDF
	echo.
	choice /C:4321 /N /M "Select partition structure for disk storage after Ventoy installation : "
	if errorlevel 1 set diskstr=UDF
	if errorlevel 2 set diskstr=exFAT
	if errorlevel 3 set diskstr=FAT32
	if errorlevel 4 set diskstr=NTFS
::===============================================================================================================
:ask
	echo.
	set free=0
	echo.   [Y]ES       [N]O
	echo.
	choice /C:YN /N /M "Do you want to leave reserved space at the end of the disk after installation? : "
	if errorlevel 2 goto :VentoyInstall
	if errorlevel 1 set free=1
	if errorlevel 1 goto :free
::===============================================================================================================
:free	
	echo.
	set /p "disksize=Type the size you want in MB : " || goto :free
	setlocal enabledelayedexpansion 
	for /f "delims=0123456789" %%a in ("!disksize!") do set "disksize="
	endlocal & set "disksize=%disksize%"

	if not defined disksize (
	echo.
	echo Please use numbers only...
	timeout /t 2 > nul
	goto :free
    )
	set value=40
	If %disksize% GEQ %value% (
	GOTO :VentoyInstall 
	) else (
	echo.
	echo Input FAT32 size as MINIMUM 40 MB...
	timeout /t 2 > nul
	goto :free
	)
::===============================================================================================================
:VentoyInstall
	call :showDiskTable
    set /p "   diskNumber=Type the disk number to install Ventoy : "
	echo.	
	echo	 Please wait...
	echo.
	
	if %free% equ 1 (
	Ventoy2Disk.exe VTOYCLI /I /PhyDrive:%diskNumber% /NOUSBCheck /%style% /FS:%diskstr% /R:%disksize%
	goto :freespaceformat
	) else (
		Ventoy2Disk.exe VTOYCLI /I /PhyDrive:%diskNumber% /NOUSBCheck /%style% /FS:%diskstr% 
	goto :end
	)	
::===============================================================================================================
:freespaceformat
	set "scriptFile=%temp%\%~nx0.%random%%random%%random%.tmp"
    > "%scriptFile%" (
		echo RESCAN
    )
    type "%scriptFile%" >nul
	diskpart /s "%scriptFile%" >nul 
    del /q "%scriptFile%" >nul

	echo.   [Y]ES       [N]O
	echo.
	choice /C:YN /N /M "Do you want to format the reserved space at the end of the disk? : "
	if errorlevel 2 goto :end
	if errorlevel 1 goto :yes
::===============================================================================================================
:yes	
	echo.
	echo.   [1] NTFS       [2] FAT32       [3] exFAT       [4] UDF
	echo.
	choice /C:4321 /N /M "Choose a partition structure to format the reserved space at the end of the disk : "
	if errorlevel 1 set diskstr=UDF
	if errorlevel 2 set diskstr=exFAT
	if errorlevel 3 set diskstr=FAT32
	if errorlevel 4 set diskstr=NTFS

	call :DriveLetter
	set "label=Ventoy"
	set q1= $Q1=(gwmi Win32_Volume -filter $('Label='+[char]34+$env:label+[char]34)).DeviceID
	set q2= $Q2=(gwmi MSFT_Partition -Namespace root\Microsoft\Windows\Storage ^|where {$_.AccessPaths -contains $Q1}).DiskNumber
	for /f %%s in ('powershell -nop -c "%q1%; if ($Q1) {%q2%; $Q2}"') do set disk=%%s

	set "scriptFile=%temp%\%~nx0.%random%%random%%random%.tmp"
    > "%scriptFile%" (
		echo LIST DISK	
		echo SELECT DISK %disk%
		echo CREATE PARTITION PRIMARY
		echo FORMAT QUICK FS=%diskstr% LABEL="Free Space"		
		echo ASSIGN LETTER=%driveletter%
    )
    type "%scriptFile%" >nul
	echo.
	echo	 Formatting free space on the disk...
	diskpart /s "%scriptFile%" >nul 
    del /q "%scriptFile%" >nul
	echo.			
	)
	
	goto :end
::===============================================================================================================
:Non-Destructive
	call :MsgBox "In the Non-Destructive Installation option, the disk to be installed Ventoy must be in NTFS format."  "VBInformation" "..:: WARNING ::.."
	echo.
	call :showDiskTable
    set /p "   diskNumber=Type the disk number for Ventoy Non-Destructive Installation : "
	echo.	
	echo	 Please wait...
	Ventoy2Disk.exe VTOYCLI /I /PhyDrive:%diskNumber% /NonDest /NOUSBCheck

	set "scriptFile=%temp%\%~nx0.%random%%random%%random%.tmp"
    > "%scriptFile%" (
		echo RESCAN
    )
    type "%scriptFile%" >nul
	diskpart /s "%scriptFile%" >nul 
    del /q "%scriptFile%" >nul

	goto :end
::===============================================================================================================
:end
	set "scriptFile=%temp%\%~nx0.%random%%random%%random%.tmp"
    > "%scriptFile%" (
		echo RESCAN
    )
    type "%scriptFile%" >nul
	diskpart /s "%scriptFile%" >nul 
    del /q "%scriptFile%" >nul

	echo.
    echo	 OK
	echo.
	call :MsgBox "Ventoy MultiBoot installation complete."  "VBInformation" ".:: Ventoy MultiBoot ::."
	choice /C:MX /N /M "Press M button for MAIN MENU -- Press the X button for EXIT : "
	if errorlevel 2 Exit
	if errorlevel 1 goto :Main
::===============================================================================================================
:Update
	call :MsgBox "If an error occurs in the Ventoy Command Line installation, error warnings will not appear. \n \nTherefore, if you encounter an error, review the Ventoy log files. "  "VBInformation" "..:: WARNING ::.."
	call :MsgBox "You should use this partition if you have already \n \nVentoy MultiBoot \n \non your disk."  "VBInformation" "..:: WARNING ::.."
	call :showDiskTable
    echo.
	set /p "   diskNumber=Select your Ventoy installed disk : "
	echo.	
	echo	 Please wait...
	Ventoy2Disk.exe VTOYCLI /U /PhyDrive:%diskNumber% /NOUSBCheck
	
	echo.
    echo	 OK
	echo.
	choice /C:MX /N /M "Press M button for MAIN MENU -- Press the X button for EXIT : "
	if errorlevel 2 Exit
	if errorlevel 1 goto :Main
::===============================================================================================================
:showDiskTable
    echo ======================================================
	echo	 ATTENTION: MAKE SURE YOU CHOOSE THE CORRECT DISK !!!
	echo.
	echo list disk | diskpart | findstr /b /c:" "
    echo ======================================================
    goto :eof
::===============================================================================================================
:DriveLetter
    set "driveletter="
    for %%a in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do cd %%a: 1>>nul 2>&1 & if errorlevel 1 set driveletter=%%a
	exit /b 0
::===============================================================================================================
:MsgBox
	Rem 64=vbInformation, 48=vbExclamation, 16=vbCritical 32=vbQuestion
    setlocal enableextensions
    set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
	>"%tempFile%" echo(WScript.Quit MsgBox(Replace("%~1","\n",vbcrlf),%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
    set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
    endlocal & exit /b %exitCode%
::===============================================================================================================
:TNCTR
	start https://www.tnctr.com/topic/1216460-ventoy-komut-kurulumu-betik-dosyas%C4%B1/
	start https://github.com/abdullah-erturk/Ventoy-Command-Line-Installer
	start https://github.com/ventoy/Ventoy/releases
	goto Main
::===============================================================================================================