@ECHO OFF
:: =================== COPYRIGHT ========================================= 
:: File:          robocopy-script.cmd
:: Author:        Christopher C. Simmons (CCS)
:: Date:          01.25.2013
:: Purpose:       To copy a folder recursively from one location (or server) to 
::                another and preserve the NTFS info
:: Assumes:       You have robocopy installed
:: Copyright:     2013 csimmons.net
::                
:: NOTICE!!!
:: csimmons.net, LLC supplies this software AS IS and makes no guarantees
:: for your use of it. csimmons.net, LLC is not responsible for any damage
:: or pain the use of this product may cause you.  Please give credit if 
:: you use this or create a derivative work.
:: =================== COPYRIGHT =========================================

:: =================== CONFIG ============================================
:: FROM Path (can be a share or fully qualified dir)
SET fromdir=\\networkshare\existingfolder
:: TO Path (can be a share or fully qualified dir)
SET todir=E:\newfolder
:: Path for log file !!!USE TRAILING SLASH!!! (default is a dir called "logs" in this script's dir)
SET logdir=%~d0%~p0logs\
:: User mode - 1=Interactive | 0=NonInteractive
SET imode=1
:: =================== CONFIG ============================================

:: =================== SCRIPT ============================================
:: !!! NO NEED TO EDIT BEYOND THIS POINT !!!
:: Make a date_time stamp like 20130125_134200
SET hh=%time:~0,2%
:: Add a zero when this is run before 10 am.
IF "%time:~0,1%"==" " set hh=0%hh:~1,1%
SET yyyymmdd_hhmmss=%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%hh%%time:~3,2%%time:~6,2%
:: Make a name for the log file
SET logfile=%logdir%%yyyymmdd_hhmmss%_%~n0.log
:: (If not exist) create a logdir directory
IF NOT EXIST %logdir% MKDIR %logdir%

:: ====== UNATTENDED MODE ======
IF %imode%== 0 (
	:: The Robocopy magic
	robocopy "%fromdir%" "%todir%" /E /SEC /COPY:DATSO /V /NP /LOG:%logfile% /B /R:10 /W:30
	EXIT
)
:: ====== UNATTENDED MODE ======

:: ====== ATTENDED MODE   ======
ECHO Hello, you are about to copy files... && ECHO from: %fromdir% && ECHO to: %todir%
ECHO It may take a while to finish so please be patient.
SET confirmcopy=NO
SET /P confirmcopy=Is this correct? ('YES' + ENTER):
IF /I "%confirmcopy%"== "YES" (
	CLS
	:: The Robocopy magic
	robocopy "%fromdir%" "%todir%" /E /SEC /COPY:DATSO /V /TEE /NP /LOG:%logfile% /B /R:10 /W:30
	CLS
	ECHO Looks like we are done.
	ECHO Log is available here: && ECHO %logfile% 
) ELSE (
	ECHO Ok, No problem.  I won't copy anything.
)
:: ====== ATTENDED MODE   ======
:: =================== SCRIPT ============================================
PAUSE
EXIT