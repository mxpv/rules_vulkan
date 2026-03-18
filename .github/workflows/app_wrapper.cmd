@echo off
setlocal

set PSEXEC=%ProgramData%\chocolatey\bin\PsExec.exe
if not exist "%PSEXEC%" (
  echo ERROR: PsExec.exe not found in Chocolatey bin.
  dir "%ProgramData%\chocolatey\bin%"
  exit /b 1
)

echo Running Vulkan smoke test via %PSEXEC%
"%PSEXEC%" -nobanner -accepteula -l -w "%CD%" cmd.exe /v:on /c "bazelisk run :app"
set EXIT_CODE=%ERRORLEVEL%
echo Vulkan smoke test exit code %EXIT_CODE%

exit /b %EXIT_CODE%
