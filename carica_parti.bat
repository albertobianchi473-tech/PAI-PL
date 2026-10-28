@echo off
setlocal enabledelayedexpansion

REM ==== CONFIGURAZIONE ====
set REPO_ROOT=D:\PAI-PL\Software\PCCS\PCCS ultma versione
set SUBDIR=PAI-PL_PCCS$SW_DEV_2.1_0001_D
set BASENAME=Setup PAI-PL_PCCS_5.2_DiagCentr_2.1_0001_D.zip
REM =========================

title Caricamento Parti DiagCentr

echo ========================================================
echo 1. Spostamento nella root del repository...
echo ========================================================
cd /d "%REPO_ROOT%" || (echo ERRORE: Cartella non trovata! & goto :err)

echo.
echo ========================================================
echo 2. Disattivazione di Git LFS (.gitattributes vuoto)...
echo ========================================================
copy nul .gitattributes >nul

echo.
echo ========================================================
echo 3. Aggiunta delle 7 parti in modalita standard...
echo ========================================================
set COUNT=0
for %%i in (001 002 003 004 005 006 007) do (
    set FILE=%SUBDIR%\!BASENAME!.%%i
    if exist "!FILE!" (
        git add -- "!FILE!" || goto :err
        echo   + !FILE!
        set /a COUNT+=1
    ) else (
        echo   ! MANCANTE: !FILE!
        goto :err
    )
)

if not "!COUNT!"=="7" (
    echo *** ERRORE: Trovati solo !COUNT! file su 7 ***
    goto :err
)

echo.
echo ========================================================
echo 4. Controllo staging (devono essere file veri, non LFS)...
echo ========================================================
echo Dimensioni in staging:
git diff --cached --stat
echo.
echo Verifica attributi LFS:
git check-attr filter -- "%SUBDIR%/%BASENAME%.001"
echo.

echo ========================================================
echo 5. Creazione del commit pulito...
echo ========================================================
git commit -m "Caricamento pulito delle 7 parti DiagCentr senza LFS" || goto :err

echo.
echo ========================================================
echo 6. Invio su GitHub (Push normale)...
echo ========================================================
REM Nota: se il push fallisce perche' il remoto e' cambiato, 
REM NON usare --force, ma contattami.
git push origin main || goto :err

echo.
echo ========================================================
echo Operazione completata con successo!
echo ========================================================
pause
exit /b 0

:err
echo.
echo *** ERRORE: Operazione interrotta. ***
echo Controlla i messaggi sopra per capire cosa e' andato storto.
pause
exit /b 1