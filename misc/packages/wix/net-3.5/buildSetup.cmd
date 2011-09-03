@echo off
rem Copyright (c) 2003-2009 The University of Wroclaw.
rem All rights reserved.
rem
rem Redistribution and use in source and binary forms, with or without
rem modification, are permitted provided that the following conditions
rem are met:
rem    1. Redistributions of source code must retain the above copyright
rem       notice, this list of conditions and the following disclaimer.
rem    2. Redistributions in binary form must reproduce the above copyright
rem       notice, this list of conditions and the following disclaimer in the
rem       documentation and/or other materials provided with the distribution.
rem    3. The name of the University may not be used to endorse or promote
rem       products derived from this software without specific prior
rem       written permission.
rem
rem THIS SOFTWARE IS PROVIDED BY THE UNIVERSITY ``AS IS'' AND ANY EXPRESS OR
rem IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
rem OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
rem NO EVENT SHALL THE UNIVERSITY BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
rem SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
rem TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
rem PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
rem LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
rem NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
rem SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

echo.

rem
rem Ensure we have all required tools
rem

if not "%WIX%"=="" goto wixSet

rem Check default wix folder
if not exist "%ProgramFiles%\Windows Installer XML v3\bin\light.exe" goto wixWow64check
echo light.exe found in "%ProgramFiles%\Windows Installer XML v3\bin" folder
set WIX=%ProgramFiles%\Windows Installer XML v3
goto wixSet

:wixWow64check
if not exist "%ProgramFiles(x86)%\Windows Installer XML v3\bin\light.exe" goto errEnvVarWix
echo light.exe found in "%ProgramFiles(x86)%\Windows Installer XML v3\bin" folder
set WIX=%ProgramFiles(x86)%\Windows Installer XML v3

:wixSet

rem
rem Ready to build the setup.exe
rem

set NemerleSetupContent=%~dp0dist
set MsiFile=%~dp0NemerleSetup.msi

echo Wixing with "%WIX%"

"%WIX%\bin\candle.exe" -ext WixNetFxExtension -sw1080 -dPlatform=x86 src/*.wxs
if not errorlevel 0 goto done
if errorlevel 1 goto done

"%WIX%\bin\light.exe"  -ext WixNetFxExtension *.wixobj -ext WixUIExtension -out "%MsiFile%" -cultures:en-us
if not errorlevel 0 goto done
if errorlevel 1 goto done

rem Clean up
del *.wixobj

echo.
echo Done.
goto done

:errEnvVarWix
echo Please specify environment variable "WIX". F.e. SET WIX=%ProgramFiles%\WIX
goto done

:done
cd "%~dp0"
pause