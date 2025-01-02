@echo off
setlocal

:: Input and output files
set INPUT_VIDEO=combined_output.mp4
set TIMELAPSE_VIDEO=timelapse.mp4

:: Step 1: Extract frames every 30 seconds
echo Extracting frames every 30 seconds...
ffmpeg -i %INPUT_VIDEO% -vf fps=1/30 frame_%%04d.jpg

:: Step 2: Create timelapse video
echo Creating timelapse video...
ffmpeg -framerate 30 -i frame_%%04d.jpg -c:v libx264 -pix_fmt yuv420p %TIMELAPSE_VIDEO%

:: Step 3: Cleanup intermediate files
echo Cleaning up intermediate frame files...
del frame_*.jpg

:: Done
echo Timelapse created: %TIMELAPSE_VIDEO%
pause
