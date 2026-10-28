@echo off
setlocal enabledelayedexpansion

title Aggiornamento Parti DiagCentr
cd /d "%~dp0"

echo ========================================================
echo 1. Verifica dei file nella cartella...
echo ========================================================
set COUNT=0
for %%i in (001 002 003 004 005 006 007) do (
    if exist "Setup PAI-PL_PCCS_5.2_DiagCentr_2.1_0001_D.zip.%%i" (
        set /a COUNT+=1
    )
)

if not "!COUNT!"=="7" (
    echo *** ERRORE: Mancano dei file! Trovati !COUNT! file su 7. ***
    pause
    exit /b 1
)
echo Trovati tutti e 7 i file.

echo.
echo ========================================================
echo 2. Aggiunta a Git...
echo ========================================================
git add "Setup PAI-PL_PCCS_5.2_DiagCentr_2.1_0001_D.zip.*"

echo.
echo ========================================================
echo 3. Commit e Push...
echo ========================================================
git commit -m "Aggiornamento delle 7 parti DiagCentr"
git push origin main

echo.
echo ========================================================
echo Operazione completata!
echo ========================================================
pause