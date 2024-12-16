@echo off
chcp 65001

cd C:\Users\User\yt-dlp\Audio

set /p URL=URL:

rem メタデータをJSON形式で保存（このファイルで情報を抽出）
yt-dlp.exe -j "%URL%" > video_metadata.json

rem 最高音質選択 flac選択 サムネイル有 出力とファイル名指定
set OPTIONS=-f bestaudio -x --audio-format flac --embed-thumbnail --write-playlist-metafiles --output "C:\Users\User\yt-dlp\Audio\%%(title)s.%%(ext)s"

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
        rem その他の情報も同様に抽出
    )
)

yt-dlp.exe %OPTIONS% "%URL%"

pause
