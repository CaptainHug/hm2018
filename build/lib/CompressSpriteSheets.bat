@echo off

echo Compressing Sprite Sheets

set PNGQUANT_EXE="%~dp0\pngquant.exe"
set SOURCE_ASSETS=%1

echo SOURCE_ASSETS = %SOURCE_ASSETS%

:: go straight to end if %SOURCE_ASSETS% does not exist
IF NOT EXIST %SOURCE_ASSETS% GOTO end

:: loop through all sprite sheets and compress using PNGQUANT_EXE
pushd %SOURCE_ASSETS%
for /R %%R in (*.png) do (
	echo Compressing sprite sheet: "%%R"

	%PNGQUANT_EXE% --force --skip-if-larger --ext .png --strip -- "%%R"
)
popd

:end

:: Add to pre-build command line options in project properties to compress sprite sheets at build
REM build\lib\CompressSpriteSheets.bat bin\assets\gfx