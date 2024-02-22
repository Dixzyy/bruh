@echo off
:: Check for administrator privileges
NET SESSION >nul 2>nul
if %errorlevel% neq 0 (
    echo Administrator privileges required. Please run this script as an administrator.
    pause
    exit /b
)

setlocal EnableDelayedExpansion

REM Check if C:\Volumeid64.exe exists
if not exist "C:\Volumeid64.exe" (
    echo Error: Volumeid64.exe not found in C:\. Please Drag Volumeid64 Into C:\.
    pause
    exit /b
)
cd C:\
REM Set the drive letter you want to change

REM Define color codes
set "colorRed=[91m"
set "colorGreen=[92m"
set "colorReset=[0m"

REM Generate a random serial
call :GenerateSerial || (
    call :LogError "Failed to generate random serial."
    goto :eof
)

REM Set the new volume IDs
for %%L in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "errorMessage="
    Volumeid64.exe %%L: !newSerial! 2>nul >nul
    if !errorlevel! neq 0 (
        set "errorMessage=Error opening drive: The system cannot find the file specified."
    )
    
    if defined errorMessage (
        call :LogError "Failed to set volume ID for %%L:."
    ) else (
        call :LogSuccess "Volume ID set successfully for %%L:."
    )
    
    call :GenerateSerial
)

pause
exit /b

:GenerateSerial
set "chars=0123456789ABCDEF"
set "newSerial="

REM Generate a formatted 8-character random serial
for /L %%i in (1,1,8) do (
    set /a "rand=!random! %% 16"
    for %%j in (!rand!) do (
        if %%i equ 5 (
            set "newSerial=!newSerial!-"
        )
        set "newSerial=!newSerial!!chars:~%%j,1!"
    )
)

exit /b

:LogSuccess
echo %colorGreen%[SUCCESS]%colorReset% %*
goto :eof

:LogError
echo %colorRed%[ERROR]%colorReset% %*
goto :eof
