@echo off

echo Creating Sprite Sheets

set TP_EXE="%~dp0\TexturePacker\TexturePacker.exe"
set SOURCE_ASSETS=%1
set DEST_FOLDER=%2
set TRIM_MODE=%3

if not defined TRIM_MODE set TRIM_MODE=Trim

echo SOURCE_ASSETS = %SOURCE_ASSETS%
echo DEST_FOLDER = %DEST_FOLDER%
echo TRIM_MODE = %TRIM_MODE%

:: loop through top level folders and make a set of sprite sheets for each folder
for /D %%D in (%SOURCE_ASSETS%/*.*) do (
	echo Processing subfolder: %%~nxD
	
	%TP_EXE% --variant 1:4x --variant 0.5:2x --variant 0.25:1x --force-identical-layout --scale-mode Smooth --format sparrow --multipack --trim-mode %TRIM_MODE% --algorithm MaxRects --border-padding 4 --shape-padding 4 --inner-padding 0 --extrude 0 --force-squared --size-constraints POT --max-width 2048 --max-height 2048 --replace "^"="%%~nxD/" --data "%DEST_FOLDER%\{v}\%%~nxD\%%~nxD_sheet_{n}.xml" --sheet "%DEST_FOLDER%\{v}\%%~nxD\%%~nxD_sheet_{n}.png" "%SOURCE_ASSETS%\%%~nxD"
)