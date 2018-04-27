REM Example code for blogpost:
REM https://undergrinder.com/tutorial/2018/04/26/let-there-be-dark.html
@echo off
cls
color 0
title Let there be dark

ECHO **********************************************************
ECHO *                    Fear of the dark                    *
ECHO **********************************************************
ECHO.

ECHO Screen off......
ECHO.

REM The ugly - set empty screensaver
REM start en empty screensaver
REM scrnsave.scr /s


REM The less ugly- 3rd party tool
:darkness
nircmd monitor off

ECHO %incr% RE-darking... Press any key %date% %time%
SET /A incr=%incr%+1
PAUSE  >nul
GOTO :darkness