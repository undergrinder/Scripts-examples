ECHO OFF
COLOR 18
TITLE SET Append value to PATH environment variable permanently
CLS

REM change the searchVal variable to add other path then the actual
SET var=%PATH%
SET searchVal=%~dp0

SET var|FINDSTR /b "var="|FINDSTR /i %searchVal% >nul
IF ERRORLEVEL 1 (SETX PATH "%PATH%;%~dp0;") ELSE (ECHO Tha PATH variable has already contains the %~dp0 path)

ECHO.
PAUSE


