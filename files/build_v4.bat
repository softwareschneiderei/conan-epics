set MYDIR=%~dp0
REM set up build parameters
cd ..
call win32.bat
REM build
cd %MYDIR%
call make EPICS_BASE="%~1"
