@echo off
setlocal

set PSEXEC=%ProgramData%\chocolatey\bin\PsExec.exe
if not exist "%PSEXEC%" (
  echo ERROR: PsExec.exe not found in Chocolatey bin.
  exit /b 1
)

"%PSEXEC%" -accepteula -l -w "%CD%" cmd.exe /v:on /c "bazelisk run :app"
set EXIT_CODE=%ERRORLEVEL%

exit /b %EXIT_CODE%
