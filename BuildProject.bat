@echo off
cd /d %~dp0
chcp 65001 > nul
echo Mental Omega Redux version 0.1 by Eagle-Vulture
echo.

set ar=ccmix.exe
set MIX=Tools\%ar%
set CSFTOOL=Tools\CSFTool.exe

: Удаление ранее скомпилированной папки
rmdir /s /q Build > nul 2> nul
mkdir Build

echo Компилирование строкой таблицы...
%CSFTOOL% -t "Source\MIX\EXPANDMD42\stringtable00.txt" -o "Source\MIX\EXPANDMD42\stringtable00.csf" -a
echo.

echo Копирование файлов клиента...
xcopy /h /y /c /r /s Source\CLIENT\ Build\
echo.

echo Копирование расширений движка...
for /f "tokens=*" %%f in ('dir "Source\" /a:a /b') do (
	copy "Source\%%f" "Build\%%f"
	)
echo.

echo Копирование предкомпилированных архивов...
for /f "tokens=*" %%f in ('dir "Source\MIX" /a:a /b') do (
	copy "Source\MIX\%%f" "Build\%%f"
	)
echo.

for /f "tokens=*" %%f in ('dir "Source\MIX\" /a:d /b') do (
	echo Компилирование %%f.mix...
	start /min "" %MIX% --create --lmd --game=ra2 --dir "Source\MIX\%%f" --mix "Build\%%f.mix"
	)

:repeat
for /f %%N in ('tasklist /FI "IMAGENAME eq %ar%" /FO CSV /NH ^| find /I /C "%ar%"') do (
	timeout /t 1 > nul
	set "count=%%N"
	)

if %count% GTR 0 (
	goto :repeat
)

echo Все MIX-архивы были собраны.

echo Настройка языковых пакетов клиента...
mkdir Build\Resources\Translations\en >nul 2> nul
copy /y "Build\EXPANDMD42.mix" "Build\Resources\Translations\en\EXPANDMD42.mix"
for /f "tokens=*" %%f in ('dir "Build\Resources\Translations\ru\MIX\" /a:d /b') do (
	%MIX% --create --lmd --game=ra2 --dir "Build\Resources\Translations\ru\MIX\%%f" --mix "Build\Resources\Translations\ru\%%f.mix"
	)
rmdir /s /q "Build\Resources\Translations\ru\MIX\"
echo.

echo Сборка проекта окончена. Пожалуйста, проверьте папку Build.
