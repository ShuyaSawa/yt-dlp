import yt_dlp
import os
import ffmpeg
import urllib.parse
from tqdm import tqdm  # プログレスバー用

def download_audio(url):
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': 'C:/Users/User/yt-dlp/Audio/%(title)s.%(ext)s',
        'extractaudio': True,
        'audioquality': 1,
        'ffmpeg_location': r"C:\Program Files\PATH_Programs-ytdpl\ffmpeg.exe",  # FFmpegのパス
        'postprocessors': [{
            'key': 'FFmpegAudioConvertor',
            'preferredcodec': 'flac',
            'preferredquality': '192',
        }],
    }

    try:
        with tqdm(total=1, desc="Downloading") as pbar:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                result = ydl.extract_info(url, download=True)
                pbar.update(1)
                filename = ydl.prepare_filename(result)
                filename = urllib.parse.unquote(filename)
                print(f"Downloaded file: {filename}")
                return filename
    except yt_dlp.DownloadError as e:
        print(f"Download error: {e}")
    except ffmpeg.Error as e:
        print(f"FFmpeg error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def convert_audio_to_flac(filename):
    # パスをエスケープしてffmpegに渡す
    escaped_filename = filename.replace("\\", "/")
    try:
        ffmpeg.input(escaped_filename).output(escaped_filename.replace(".webm", ".flac")).run()
        print(f"Conversion completed: {escaped_filename}")
    except ffmpeg.Error as e:
        print(f"Error converting audio: {e}")

def main():
    url = input("URLを入力してください: ")
    filename = download_audio(url)
    if filename:
        convert_audio_to_flac(filename)
    else:
        print("Download failed.")

if __name__ == '__main__':
    main()