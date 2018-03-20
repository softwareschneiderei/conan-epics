set MYDIR=%~dp0
REM set up build parameters
call win32.bat
REM build
cd %MYDIR%
call make
