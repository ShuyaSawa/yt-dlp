@echo off
chcp 65001

cd C:\Users\User\yt-dlp\Audio

set /p URL=URL:

rem メタデータなしで音声のみダウンロード
yt-dlp.exe -v -f bestaudio -x --audio-format flac --output "C:\Users\User\yt-dlp\Audio\%%(title)s.%%(ext)s" "%URL%"

rem メタデータをJSON形式で保存（このファイルで情報を抽出）
yt-dlp.exe -j "%URL%" --write-thumbnail > video_metadata.json

rem メタデータをテキストファイルに書き込む（PowerShellを使用してUTF-8で書き込む）
for /f "delims=" %%i in ('type video_metadata.json') do (
    set "json=%%i"
    for /f "tokens=2 delims=:," %%a in ("!json!") do (
        rem タイトルの抽出
        if "%%a"=="title" (
            powershell -Command "Add-Content -Path 'video_info.txt' -Value 'タイトル: %%b' -Encoding UTF8"
        )
        rem アーティストの抽出
        if "%%a"=="uploader" (
            powershell -Command "Add-Content -Path 'video_info.txt' -Value 'アーティスト: %%b' -Encoding UTF8"
        )
        rem アルバムの抽出
        if "%%a"=="album" (
            powershell -Command "Add-Content -Path 'video_info.txt' -Value 'アルバム: %%b' -Encoding UTF8"
        )
        rem リリース年の抽出
        if "%%a"=="release_year" (
            powershell -Command "Add-Content -Path 'video_info.txt' -Value 'リリース年: %%b' -Encoding UTF8"
        )
    )
)

rem メタデータなしで作成したFLACファイルを上書き
yt-dlp.exe -f bestaudio -x --audio-format flac --embed-thumbnail --output "C:\Users\User\yt-dlp\Audio\%%(title)s.%%(ext)s" "%URL%"

rem 一時的にファイル名を変更してから、元に戻す
set "temp_filename=audio_temp.flac"
set "final_filename=熱異常 ⧸ いよわ feat.足立レイ（Heat abnormal ⧸ Iyowa feat.Adachi Rei）.flac"

rem 一時ファイル名を変更
ren "C:\Users\User\yt-dlp\Audio\%final_filename%" "%temp_filename%"

rem メタデータなしで作成したFLACファイルを削除
del "C:\Users\User\yt-dlp\Audio\%final_filename%"

rem サムネイルを適切なファイル名にリネーム
ren "C:\Users\User\yt-dlp\Audio\熱異常 ⧸ いよわ feat.足立レイ（Heat abnormal ⧸ Iyowa feat.Adachi Rei）.webp" "thumbnail.webp"

rem FLACファイルにサムネイルを埋め込む
ffmpeg -i "C:\Users\User\yt-dlp\Audio\%temp_filename%" -i "C:\Users\User\yt-dlp\Audio\thumbnail.webp" -map 0 -map 1 -c copy -id3v2_version 3 "C:\Users\User\yt-dlp\Audio\%final_filename%"

rem サムネイルの名前を元に戻す
ren "C:\Users\User\yt-dlp\Audio\thumbnail.webp" "熱異常 ⧸ いよわ feat.足立レイ（Heat abnormal ⧸ Iyowa feat.Adachi Rei）.webp"

rem 一時ファイルを削除
del "C:\Users\User\yt-dlp\Audio\%temp_filename%"

pause
