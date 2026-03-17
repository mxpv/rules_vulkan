@echo off
setlocal EnableDelayedExpansion

set LOG=%TEMP%\bazel_smoke_win.log
set STATUS=%TEMP%\bazel_smoke_win.status

del "%LOG%" "%STATUS%" 2>nul

runas /trustlevel:0x20000 ^
  "cmd.exe /v:on /c \"cd /d %CD% && bazelisk run :app > \"%LOG%\" 2>&1 & echo !errorlevel! > \"%STATUS%\"\""

if not exist "%STATUS%" (
  echo runas failed to produce a status file
  if exist "%LOG%" type "%LOG%"
  exit /b 1
)

type "%LOG%"
set /p EXIT_CODE=<"%STATUS%"

exit /b %EXIT_CODE%
