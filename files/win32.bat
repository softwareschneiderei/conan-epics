@ECHO OFF
REM *************************************************************************
REM  Copyright (c) 2002 The University of Chicago, as Operator of Argonne
REM      National Laboratory.
REM  Copyright (c) 2002 The Regents of the University of California, as
REM      Operator of Los Alamos National Laboratory.
REM  EPICS BASE Versions 3.13.7
REM  and higher are distributed subject to a Software License Agreement found
REM  in file LICENSE that is included with this distribution.
REM *************************************************************************
REM
REM  Site-specific EPICS environment settings
REM
REM  sites should modify these definitions

REM ======================================================
REM    ====== REQUIRED ENVIRONMENT VARIABLES FOLLOW ======
REM ======================================================

REM ======================================================
REM   ---------------- WINDOWS ---------------------------
REM ======================================================
REM ----- WIN95 -----
REM set PATH=C:\WINDOWS;C:\WINDOWS\COMMAND
REM ----- WINNT, WIN2000  -----
REM set PATH=C:\WINNT;C:\WINNT\SYSTEM32
REM ----- WINXP, Vista, Windows 7 -----
REM set PATH=C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\SYSTEM32\Wbem

REM ======================================================
REM   ---------------- make and perl ---------------------
REM ======================================================

REM   --------------- ActiveState perl -------------------
REM set PATH=C:\Strawberry\perl\bin;%PATH%

REM    --------------- mingw make ------------------------
REM set PATH=C:\mingw-make\bin;%PATH%
REM set PATH=C:\mingw-make82-3\bin;%PATH%

REM   --------------- gnuwin32 make ----------------------
REM set PATH=C:\gnuwin32\bin;%PATH%

REM ======================================================
REM ---------------- cygwin tools ------------------------
REM ======================================================
REM    (make & perl if above perl and make are REMs)
REM    Dont use cygwin GNU make and Perl!
REM    cygwin contains tk/tcl, vim, perl, and many unix tools
REM    need grep from here NOT from cvs directory
REM set PATH=%PATH%;.;..
REM set PATH=%PATH%;c:\cygwin\bin

REM ======================================================
REM --------------- EPICS --------------------------------
REM ======================================================
REM default to x64
if "%EPICS_HOST_ARCH%" == "" (
set EPICS_HOST_ARCH=windows-x64
)

REM ======================================================
REM   --------------- Visual c++ -------------------------
REM ======================================================
REM for now just VS2015 and VS2017
if exist "C:\Program files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" (
    set VCVERSION=14.0
    set "VCVARALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\"
)

REM for VS2017 the install is different for the 'free' version and the 'pro' version
if exist "C:\Program files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build" (
    set VCVERSION=15.0
    set "VCVARALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build"
)
if exist "C:\Program files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build" (
    set VCVERSION=15.0
    set "VCVARALLDIR=C:\Program files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build"
)

if exist "%VCVARALLDIR%\vcvarsall.bat" (
    if "%EPICS_HOST_ARCH:~0,11%" == "windows-x64" (
        @echo Using Visual Studio %VCVERSION% x64 compiler
        call "%VCVARALLDIR%\vcvarsall.bat" x64
    ) else (   
        if "%EPICS_HOST_ARCH:~0,9%" == "win32-x86" (
            @echo Using Visual Studio %VCVERSION% x86 compiler
            call "%VCVARALLDIR%\vcvarsall.bat" x86
        ) else (
            @echo Could not find correct compiler architecture for Visual Studio %VCVERSION%
        )
    )
) else (
    @echo Could not find Visual Studio %VCVERSION% vcvarsall.bat
)


REM ======================================================
REM ------- OPTIONAL ENVIRONMENT VARIABLES FOLLOW --------
REM ======================================================

REM ======================================================
REM ----------------- remote CVS -------------------------
REM ======================================================
REM set CVS_RSH=c:/cygwin/bin/ssh.exe
REM set CVSROOT=:ext:jba@aps.anl.gov:/usr/local/epicsmgr/cvsroot
REM set HOME=c:/users/%USERNAME%
REM set HOME=c:/users/jba

REM ======================================================
REM ------------------- Bazaar ---------------------------
REM ======================================================
REM set PATH=%PATH%;C:\Program files\Bazaar

REM ======================================================
REM ----------------- GNU make flags ---------------------
REM ======================================================
set MAKEFLAGS=-w

REM ======================================================
REM -------------- vim (use cygwin vim ) -----------------
REM ======================================================
REM HOME needed by vim to write .viminfo file.
REM VIM needed by vim to find _vimrc file.
REM set VIM=c:\cygwin

REM ======================================================
REM --------------- Epics Channel Access -----------------
REM    Modify and uncomment the following lines
REM    to override the base/configure/CONFIG_ENV defaults
REM ======================================================
REM set EPICS_CA_ADDR_LIST=n.n.n.n  n.n.n.n
REM set EPICS_CA_AUTO_ADDR_LIST=YES

REM set EPICS_CA_CONN_TMO=30.0
REM set EPICS_CA_BEACON_PERIOD=15.0
REM set EPICS_CA_REPEATER_PORT=5065
REM set EPICS_CA_SERVER_PORT=5064
REM set EPICS_TS_MIN_WEST=420

REM ======================================================
REM --------------- JAVA ---------------------------------
REM ======================================================
REM    Needed for java extensions
REM set CLASSPATH=G:\epics\extensions\javalib
REM set PATH=%PATH%;C:\j2sdk1.4.1_01\bin
REM set CLASSPATH=%CLASSPATH%;C:\j2sdk1.4.1_01\lib\tools.jar

REM ======================================================
REM --------------- Exceed -------------------------------
REM    Needed for X11 extensions
REM ======================================================
REM set EX_VER=7.10
REM set EX_VER=12.00
REM set EX_VER=14.00
REM set PATH=%PATH%;C:\Exceed%EX_VER%\XDK\
REM set PATH=%PATH%;C:\Program Files\Hummingbird\Connectivity\%EX_VER%\Exceed\
