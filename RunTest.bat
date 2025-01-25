@echo off
call BuildProject.bat
timeout /t 5 > nul
echo.

echo Копирование файлов в папку _Test...
xcopy /h /y /c /r /s Build\ _Test\
echo.

echo Запуск клиента
timeout /t 5 > nul
start "" _Test\Resources\clientxna.exe
