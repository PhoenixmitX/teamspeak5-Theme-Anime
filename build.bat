@echo off

setlocal EnableExtensions EnableDelayedExpansion

jq --version > nul

if errorlevel 1 (
  echo.
  echo "jq is not installed."
  echo "jq is required to build the project."
  echo "Installing jq..."
  curl -L -o jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe
)

echo.
echo "Building project..."

REM create an empty build folder
del /q /s build\*
mkdir build\de.wargamer.anime.teamspeak

REM collect files
for /r "styles" %%F in (*.css,*.png,*.gif) do (
  @REM ignore template.css
  if NOT "%%~nxF" == "template.css" (
    copy "%%F" "build\de.wargamer.anime.teamspeak\"
  )
)

REM merge json files
echo [] > build\themes.json
for /r "styles" %%F in (*.json) do (
  @REM ignore package.json
  if NOT "%%~nxF" == "package.json" (
    @REM add object to array
    jq -s ".[0] + [.[1]]" build\themes.json "%%F" > build\themes.json.tmp
    move /y build\themes.json.tmp build\themes.json
  )
)
jq -c --slurpfile themes build\themes.json ".content.themes |= $themes[0]" styles\package.json > build\de.wargamer.anime.teamspeak\package.json

@REM zip files
cd build
tar -c -f AnimeSpeak.zip de.wargamer.anime.teamspeak

endlocal
