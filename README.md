# WAV to MP3 PowerShell Converter

"WAV to MP3 PowerShell Converter" is a PowerShell script that converts WAV audio files to MP3. The conversion is done in bulk, from the source folder. 

Steps:
- The script searches for all WAV files that exist in the given source folder.
- Copies all WAV files from the source folder to the destination folder. 
- Deletes all MP3 files from the destination folder. 
- Converts all WAV files it has transferred to MP3. 
- Deletes all WAV files in the destination folder leaving only MP3s
- Renames MP3 files

! Be careful the destination folder should not have any MP3 file you need because the script will delete it

*To convert the tracks from WAV to MP3 the script uses the [SOX library](https://sox.sourceforge.net/)*

## Installation

- Install sox-14.4.2-win32.exe or download and install it from [SOX official page](https://sox.sourceforge.net/) 
- Move all files from sox-14.4.0-libmad-libmp3lame folder into SOX installation path (it should be something like C:\Program Files (x86)\sox-14-4-2)
- Open PowerShell with admin rights and run ```Set-ExecutionPolicy RemoteSigned```
- Configure settings.txt, runSOXforAllFilesInsideFolder.bat and index.ps1 (see below the examples)
- Ready for use

## Settings

- Inside the file settings.txt you should define the name of the files you want from the script to process. For example if you want all WAV files the value will be *.wav. If you want all files 2022-summer.wav, 2021-summer.wav, etc then you will set *-summer.wav

- The date parameter is used in case you want to edit some new tracks based on the last run date of the script. If you want this parameter to be used, you should to make changes to the index.ps1 file as well, line 14 set  $convertFilesBasedOnLastWriteTime = 1.

- The source parameter has the value of the source folder. For example "C:\Users\myUser\Desktop\my audio files\wav files" or "E:\*\*\"

- The destination parameter has the destination folder as its value. For example "C:\Users\myUser\Desktop\testFolder\". You have to set the destination path to the file runSOXforAllFilesInsideFolder.bat on the first line, "C:\Users\myUser\Desktop\audio folder"

## Usage

If you have done all the above steps then the only thing left is to right click on index.ps1 and execute

## License

[MIT](https://choosealicense.com/licenses/mit/)