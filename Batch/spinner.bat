REM Instructions : Call this script from other batch to show spinner
REM                The parent script should be like this:
REM                  
REM                     ::spinner start
REM                     ECHO spinner tmp fajl >spinner.tmp
REM                     START spinner.bat spinner.tmp
REM                     
REM                        ::DO THINGS, while the spinner is shown in separate window
REM                     
REM                     ::spinner stop
REM                     del spinner.tmp
REM
REM undergrinder 2018          

@ECHO OFF

TITLE Processing...
COLOR 18

SETLOCAL ENABLEDELAYEDEXPANSION
SET COUNT=1
SET FILE_FOR_LOOP=%1

:BEGIN

  IF !COUNT! EQU 1   CLS
  IF !COUNT! EQU 300 CLS
  IF !COUNT! EQU 600 CLS
  IF !COUNT! EQU 900 CLS

  IF !COUNT! EQU 1    ECHO Processing   \
  IF !COUNT! EQU 300  ECHO Processing.  -
  IF !COUNT! EQU 600  ECHO Processing.. /
  IF !COUNT! EQU 900  ECHO Processing...-
  IF !COUNT! EQU 1200 (
    SET COUNT=1
  ) ELSE (
    SET /A COUNT+=1
  )

IF EXIST %FILE_FOR_LOOP% GOTO :BEGIN

EXIT

