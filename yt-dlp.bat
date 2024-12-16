@echo off
cd C:\Users\User\yt-dlp\Video
set OPTIONS=
set /p URL=URL:
yt-dlp.exe %OPTIONS% "%URL%"