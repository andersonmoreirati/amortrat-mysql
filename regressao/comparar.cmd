@echo off
REM ---------------------------------------------------------------------------
REM  Compara as duas execucoes de um roteiro e abre o relatorio.
REM
REM  Uso:
REM    comparar.cmd                      (usa 00-abertura)
REM    comparar.cmd 02-cliente
REM ---------------------------------------------------------------------------

setlocal

set "ROTEIRO=%~1"
if "%ROTEIRO%"=="" set "ROTEIRO=00-abertura"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Compare-Run.ps1" ^
  -Roteiro "%ROTEIRO%"

set "HTML=%~dp0resultados\%ROTEIRO%\relatorio-paradox-x-mysql.html"
if exist "%HTML%" (
  echo.
  echo  abrindo %HTML%
  start "" "%HTML%"
)

endlocal
