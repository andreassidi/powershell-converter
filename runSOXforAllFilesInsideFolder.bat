cd %1
for /R %%f in (*.wav) do (
 "C:\Program Files (x86)\sox-14-4-2\sox" "%%f" "%%f.mp3"
) 
