#/\のような特殊文字不可
import yt_dlp
import os
from mutagen.flac import FLAC, Picture
import requests
import re
import urllib.parse

def download_and_embed_thumbnail(url):
    # ダウンロード先ディレクトリ
    download_dir = "C:/Users/User/yt-dlp/Audio"
    os.makedirs(download_dir, exist_ok=True)

    # yt-dlpオプション設定
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': os.path.join(download_dir, '%(title)s.%(ext)s'),
        'postprocessors': [
            {
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'flac',
            },
        ],
    }

    # URLから音声をダウンロード
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info_dict = ydl.extract_info(url, download=True)
        title = info_dict.get('title', 'Unknown Title')
        print(f"音声 '{title}' をダウンロードしました。")

    # URLエンコードされた文字列をデコード
    safe_title = urllib.parse.unquote(title)  # URLエンコードをデコード
    flac_file_path = os.path.join(download_dir, f"{safe_title}.flac")

    if not os.path.exists(flac_file_path):
        print(f"エラー: '{flac_file_path}' が見つかりません。変換に失敗した可能性があります。")
        return

    # サムネイルURL取得
    thumbnail_url = info_dict.get('thumbnail', None)
    if not thumbnail_url:
        print("サムネイルURLが見つかりませんでした。")
        return

    # サムネイルをダウンロード
    try:
        response = requests.get(thumbnail_url)
        if response.status_code == 200:
            thumbnail_data = response.content
        else:
            print(f"サムネイルのダウンロードに失敗しました (HTTPステータス: {response.status_code})")
            return
    except Exception as e:
        print(f"サムネイルのダウンロード中にエラーが発生しました: {e}")
        return

    # サムネイルをFLACファイルに埋め込む
    try:
        audio_file = FLAC(flac_file_path)
        picture = Picture()
        picture.type = 3  # Cover (front)
        picture.mime = "image/jpeg"
        picture.desc = "Cover"
        picture.data = thumbnail_data
        audio_file.add_picture(picture)
        audio_file.save()
        print(f"サムネイルが音声ファイル '{flac_file_path}' に埋め込まれました。")
    except Exception as e:
        print(f"エラー: サムネイルの埋め込みに失敗しました: {e}")

# 実行部分
if __name__ == "__main__":
    url = input("URLを入力してください: ")
    download_and_embed_thumbnail(url)
