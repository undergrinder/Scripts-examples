@echo off

REM This batch start the 64bit version of powershell, with custom profile script
REM This file is useful when you try start powershell 64 bit from a 32bit software for example total commander

ECHO *********************************************
ECHO *       Start Powershell in 64 bit          *
ECHO *********************************************
ECHO.
ECHO C:\Windows\sysnative\WindowsPowerShell\v1.0\powershell.exe
ECHO.

C:\Windows\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -noexit -file "E:\UNDERGRINDER\pshell_profile.ps1"