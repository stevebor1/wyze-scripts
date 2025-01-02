@echo off
setlocal enabledelayedexpansion

:: Set the output file name
set OUTPUT_FILE=combined_output.mp4

:: Create a temporary file list
set FILE_LIST=files_to_combine.txt
if exist %FILE_LIST% del %FILE_LIST%

:: Log file for debug
set LOG_FILE=process_log.txt
if exist %LOG_FILE% del %LOG_FILE%

:: Initialize logs
echo Starting MP4 file combination process... > %LOG_FILE%
echo Output file: %OUTPUT_FILE% >> %LOG_FILE%
echo. >> %LOG_FILE%

:: Check if FFmpeg is available in the PATH
echo Checking for FFmpeg... >> %LOG_FILE%
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo Error: FFmpeg is not found in the PATH. >> %LOG_FILE%
    echo Please install FFmpeg and add it to your PATH. >> %LOG_FILE%
    echo.
    echo ===== PROCESS LOG =====
    type %LOG_FILE%
    echo =======================
    echo.
    echo Process terminated. Press any key to close the window.
    pause > nul
    exit /b 1
) else (
    echo FFmpeg found in PATH. >> %LOG_FILE%
)

:: Traverse each folder in the current directory that matches the pattern 00 to 23
for /D %%H in (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23) do (
    if exist %%H (
        echo Processing folder: %%H >> %LOG_FILE%
        pushd %%H
        for %%M in (*.mp4) do (
            echo Found file: %%H\%%M >> ..\%LOG_FILE%
            echo file '%%~dpH%%M' >> ..\%FILE_LIST%
        )
        popd
    )
)

:: Combine all the files listed in the file list
if exist %FILE_LIST% (
    echo Combining files... >> %LOG_FILE%
    ffmpeg -f concat -safe 0 -i %FILE_LIST% -c:v copy -c:a aac -b:a 128k %OUTPUT_FILE%
    if %ERRORLEVEL% equ 0 (
        echo Combined file created successfully: %OUTPUT_FILE% >> %LOG_FILE%
    ) else (
        echo Error: FFmpeg failed to create the combined file. >> %LOG_FILE%
    )
) else (
    echo No MP4 files found for combining. >> %LOG_FILE%
)

:: Clean up
if exist %FILE_LIST% del %FILE_LIST%

:: Display the log for user review
echo.
echo ===== PROCESS LOG =====
type %LOG_FILE%
echo =======================
echo.

:: Prompt to close the window
echo Process completed. Press any key to close the window.
pause > nul

endlocal
