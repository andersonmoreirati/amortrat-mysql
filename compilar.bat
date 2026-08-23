@echo off
set LOG=D:\AMORTRAT\mysql\code\build.log

echo Compilando amortrat_mysql...
call "C:\Program Files (x86)\Embarcadero\RAD Studio\7.0\bin\rsvars.bat" > nul

msbuild amortrat_mysql.dproj /t:Build /p:Config=Debug /nologo /v:minimal > "%LOG%" 2>&1

echo.
findstr /i "error\|fatal\|E[0-9][0-9][0-9][0-9]\|F[0-9][0-9][0-9][0-9]" "%LOG%" > nul
if %ERRORLEVEL% == 0 (
    echo ============================================
    echo  BUILD FALHOU — erros encontrados:
    echo ============================================
    findstr /i "error\|fatal\|E[0-9][0-9][0-9][0-9]\|F[0-9][0-9][0-9][0-9]" "%LOG%"
) else (
    echo ============================================
    echo  BUILD OK — sem erros
    echo ============================================
    findstr /i "warning\|lines\|bytes" "%LOG%" | findstr /i "lines\|bytes"
)

echo.
echo Log completo em: %LOG%
pause
