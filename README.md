# conan-epics

Conan package for EPICS Base  and V4 (http://www.aps.anl.gov/epics/). Developed
and tested for linux-x86_64 (CentOS 7) and darwin-x86 (macOS). This package
contains a limited subset of the EPICS tools.

## For Windows

In EPICS base the file win32.bat is used for configuring the build system on Windows. In EPICS base it is found in base-3.1X.X.X\startup

The win32.bat file in this repository is intended to be a drop-in replacement to allow EPICS to be built on the DMSC's Jenkins system.

It requires the following items to be installed:

    GNU Make for Windows (http://gnuwin32.sourceforge.net/packages/make.htm)
    Strawberry Perl (64-bit) (http://strawberryperl.com/)
    Visual Studio 2015 or 2017

And it expects make and perl to be in the path.
