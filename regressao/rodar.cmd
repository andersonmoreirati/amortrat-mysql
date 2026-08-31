@echo off
REM ---------------------------------------------------------------------------
REM  Executa um roteiro de regressao sem depender da Execution Policy.
REM
REM  O PowerShell vem com policy Restricted por padrao no Windows e recusa
REM  rodar .ps1. Em vez de alterar a politica da maquina, este wrapper passa
REM  -ExecutionPolicy Bypass apenas para ESTE processo.
REM
REM  Uso:
REM    rodar.cmd paradox ADMIN 4044
REM    rodar.cmd mysql   ADMIN 4044
REM    rodar.cmd paradox ADMIN 4044 roteiros\02-cliente.json
REM ---------------------------------------------------------------------------

setlocal

set "ROTULO=%~1"
set "USUARIO=%~2"
set "SENHA=%~3"
set "ROTEIRO=%~4"

if "%ROTULO%"==""  goto :ajuda
if "%USUARIO%"=="" goto :ajuda
if "%ROTEIRO%"=="" set "ROTEIRO=roteiros\00-abertura.json"

if /I "%ROTULO%"=="paradox" (
  set "EXE=C:\Amortrat\code\amortrat.exe"
) else if /I "%ROTULO%"=="mysql" (
  set "EXE=C:\Amortrat\mysql\code\amortrat.exe"
) else (
  echo Rotulo deve ser 'paradox' ou 'mysql' ^(recebido: %ROTULO%^)
  goto :fim
)

echo.
echo  roteiro : %ROTEIRO%
echo  versao  : %ROTULO%
echo  exe     : %EXE%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Run-Roteiro.ps1" ^
  -Roteiro "%~dp0%ROTEIRO%" -Exe "%EXE%" -Rotulo "%ROTULO%" ^
  -Usuario "%USUARIO%" -Senha "%SENHA%"

goto :fim

:ajuda
echo.
echo  Uso: rodar.cmd ^<paradox^|mysql^> ^<usuario^> ^<senha^> [roteiro.json]
echo.
echo  Exemplos:
echo    rodar.cmd paradox ADMIN 4044
echo    rodar.cmd mysql   ADMIN 4044
echo    rodar.cmd mysql   ADMIN 4044 roteiros\02-cliente.json
echo.

:fim
endlocal
