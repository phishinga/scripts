@echo off

for /L %%i in (1,1,20) do (
  set "response="
  for /f "delims=" %%A in ('curl --write-out %%{http_code}%% --silent --output nul http://emphonic.com') do set "response=%%A"

  if "%response%" equ "200" (
    echo %time% : Iteration %%i: The website is up and running. Response code: %response%
  ) elseif "%response%" equ "404" (
    echo %time% : Iteration %%i: The page was not found. Response code: %response%
  ) elseif "%response%" equ "429" (
    echo %time% : Iteration %%i: Rate limit is exceeded. Response code: %response%
  ) else (
    echo %time% : Iteration %%i: An unexpected response was received. Response code: %response%
  )

  timeout /T 1 >nul
)
