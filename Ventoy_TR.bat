
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
echo x = WshShell.Popup ("Isletim Sistemi Windows 10 degil. Betik dosyasi sadece Windows 10 ve uzerinde calisir. 5 saniye icinde islem sonlandirilacak.",5, "..:: DIKKAT ::..") >> %temp%\msg.vbs
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
echo	 	  1 - USB/HDD D˜SK B™LšMšNE Ventoy KUR
echo.
echo	 	  2 - VENTOY GšNCELLE
echo.
echo	 	  3 - VENTOY GITHUB SAYFALARINI Z˜YARET ED˜N
echo.
echo	 	  4 - €IKIž
echo.
echo =====================================================================================
echo.
choice /c 1234 /cs /n /m "Se‡iminizi Yapn : "
echo.
if errorlevel 4 Exit
if errorlevel 3 goto :TNCTR
if errorlevel 2 goto :Update
if errorlevel 1 goto :Ventoy
echo.
::===============================================================================================================
:Ventoy
	call :MsgBox "Ventoy Komut Destekli kurulumda eger hata olusursa hata uyarilari gorunmeyecektir. \n \nBu nedenle bir hata ile karsilasirsaniz Ventoy log dosyalarini inceleyin. "  "VBInformation" "..:: UYARI ::.."
	echo.   [T]ahribatsz Kurulum       [F]ormatl Kurulum
	echo.
	set dest=0
	choice /C:TF /N /M "Ventoy kurulumunun nasl yaplmasn istersiniz? : "
	if errorlevel 2 goto :Destructive
	if errorlevel 1 set dest=1
	if errorlevel 1 goto :Non-Destructive 
::===============================================================================================================
:Destructive
	echo.
	set style=
	echo.   [G]PT       [M]BR 
	echo.
	choice /C:GM /N /M "Ventoy kurulumu yaplacak diskin yapsn se‡in : "
	if errorlevel 1 set style=GPT
	if errorlevel 2 set style=MBR
	echo.
	
	set diskstr=
	echo.   [1] NTFS       [2] FAT32       [3] exFAT       [4] UDF
	echo.
	choice /C:4321 /N /M "Ventoy kurulumu sonras diskin depolama alan i‡in b”lm yapsn se‡in : "
	if errorlevel 1 set diskstr=UDF
	if errorlevel 2 set diskstr=exFAT
	if errorlevel 3 set diskstr=FAT32
	if errorlevel 4 set diskstr=NTFS
::===============================================================================================================
:ask
	echo.
	set free=0
	echo.   [E]VET       [H]AYIR
	echo.
	choice /C:EH /N /M "Ventoy kurulumu sonras diskin sonunda ayrlmŸ alan brakmak ister misiniz? : "
	if errorlevel 2 goto :VentoyInstall
	if errorlevel 1 set free=1
	if errorlevel 1 goto :free
::===============================================================================================================
:free	
	echo.
	set /p "disksize=˜stediginiz miktarda boyutu MB cinsinden yazn: " || goto :free
	setlocal enabledelayedexpansion 
	for /f "delims=0123456789" %%a in ("!disksize!") do set "disksize="
	endlocal & set "disksize=%disksize%"

	if not defined disksize (
	echo.
	echo Ltfen sadece rakam kullann...
	timeout /t 2 > nul
	goto :free
    )
	set value=40
	If %disksize% GEQ %value% (
	GOTO :VentoyInstall 
	) else (
	echo.
	echo AyrlmŸ alan boyutunu EN AZ 40 MB olarak girin...
	timeout /t 2 > nul
	goto :free
	)
::===============================================================================================================
:VentoyInstall
	call :showDiskTable
    set /p "   diskNumber=Ventoy yklenecek disk numarasn yazn: "
	echo.	
	echo	 Ltfen bekleyin...
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

	echo.   [E]VET       [H]AYIR
	echo.
	choice /C:EH /N /M "Disk sonunda ayrlmŸ alan bi‡imlendirmek ister misiniz? : "
	if errorlevel 2 goto :end
	if errorlevel 1 goto :yes
::===============================================================================================================
:yes	
	echo.
	echo.   [1] NTFS       [2] FAT32       [3] exFAT       [4] UDF
	echo.
	choice /C:4321 /N /M "Disk sonunda ayrlmŸ alan bi‡imlendirmek i‡in bir b”lm yapsn se‡in : "
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
	echo	 Diskin boŸ alan bi‡imlendiriliyor...
	diskpart /s "%scriptFile%" >nul 
    del /q "%scriptFile%" >nul
	echo.			
	)
	
	goto :end
::===============================================================================================================
:Non-Destructive
	call :MsgBox "Tahribatsiz Kurulum seceneginde Ventoy kurulacak disk kesinlikle NTFS formatinda olmalidir."  "VBInformation" "..:: DIKKAT ::.."
	echo.
	call :showDiskTable
    set /p "   diskNumber=Ventoy Tahribatsz Kurulum yaplacak disk numarasn yazn : "
	echo.	
	echo	 Ltfen bekleyin...
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
    echo	 ˜žLEM TAMAMLANDI
	echo.
	call :MsgBox "Ventoy MultiBoot kurulumu tamamlandi."  "VBInformation" ".:: Ventoy MultiBoot ::."
	choice /C:AX /N /M "ANA MENš i‡in A -- €IKIž i‡in X tusuna basn : "
	if errorlevel 2 Exit
	if errorlevel 1 goto :Main
::===============================================================================================================
:Update
	call :MsgBox "Ventoy Komut Destekli kurulumda eger hata olusursa hata uyarilari gorunmeyecektir. \n \nBu nedenle bir hata ile karsilasirsaniz Ventoy log dosyalarini inceleyin. "  "VBInformation" "..:: UYARI ::.."
	call :MsgBox "Bu bolumu diskinizde zaten \n \nVentoy \n \nvarsa kullanmalisiniz."  "VBInformation" "..:: DIKKAT ::.."
	call :showDiskTable
    echo.
	set /p "   diskNumber=Ventoy ykl diskinizi se‡in : "
	echo.	
	echo	 Ltfen bekleyin...
	Ventoy2Disk.exe VTOYCLI /U /PhyDrive:%diskNumber% /NOUSBCheck
	
	echo.
    echo	 ˜žLEM TAMAMLANDI
	echo.
	choice /C:AX /N /M "ANA MENš i‡in A -- €IKIž i‡in X tusuna basn : "
	if errorlevel 2 Exit
	if errorlevel 1 goto :Main
::===============================================================================================================
:showDiskTable
    echo ======================================================
	echo	 D˜KKAT : DO¦RU D˜SK˜ SE€T˜¦˜N˜ZDEN EM˜N OLUN !!!
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