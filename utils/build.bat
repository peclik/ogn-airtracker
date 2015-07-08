@echo off

set TOOLCHAIN_PATH=c:\apps\gcc-arm
set PATH=%TOOLCHAIN_PATH%\bin;c:\apps\bin;%PATH%

rem make -C ../src "MKDIR=../mkdir.exe" "TPATH=%TOOLCHAIN_PATH%/bin" -f makefile" %1 %2 %3 %4
make -C ../src "WITH_OPTS=lcd5110 buttons" "MKDIR=../mkdir.exe" "TPATH=%TOOLCHAIN_PATH%/bin" -f makefile" %1 %2 %3 %4
REM ~ make -C ../src "WITH_OPTS=bmp180 beeper i2c1" "MKDIR=../mkdir.exe" "TPATH=%TOOLCHAIN_PATH%/bin" -f makefile" %1 %2 %3 %4

pause
