#mainScript is called at the bottom of the file
function mainScript() {

    $settingsFilePath = ($PSScriptRoot + '\settings.txt');
    $settings = Get-Content $settingsFilePath; 
    $results = getSettingsData -settings $settings;
    
    $fileName = $results[0];
    $date = $results[1];
    $source = $results[2];
    $destination = $results[3];

    #0:false, 1:true
    $convertFilesBasedOnLastWriteTime = 0; 

    if( -not $convertFilesBasedOnLastWriteTime){
        #Using this value, the copySourceFilesToDestination function will copy all files
        $date = '01-01-1900';
    }

    if ( (-not(test-path $source)) -and (-not(test-path ($destination + '*.mp3')))) { 
        write-host 'Either the destination or the source does not exist!'
        return ;
    } 
    
    if ( test-path ($destination + '*.mp3')) { 
        cmd.exe /c  del ($destination + '*.mp3');
        write-host "All the old MP3 files inside the destination folder have been deleted";
    } 
    
    copySourceFilesToDestination -sourceDir $source -destinationDir $destination -fileName $fileName -date $date;
    $runSOXbatchFile = ($PSScriptRoot + '\runSOXforAllFilesInsideFolder.bat');
    cmd.exe /c ($runSOXbatchFile);
    
    #Deletes all .wav files from destination folder
    if ( test-path ($destination + '*.wav') ) {  
        cmd.exe /c  del ($destination + '*.wav');
    } 
    
    #Deletes the word .WAV from converted files
    get-childitem $destination  | rename-item -NewName { $_.name -replace (".WAV", "Conv") }; 

    #Updates the date inside file settings.txt
    updateFileDate -date $date -settingsFilePath $settingsFilePath;
    
}

function getSettingsData($settings) {

    if ( -not($settings[0].contains('file'))) {
        write-host "There is not settings in the file"
        return ;
    }
    if ( -not($settings[1].contains('date'))) {
        write-host "There is not dates inside settings"
        return ;
    }
    if ( -not($settings[2].contains('source'))) {
        write-host "There is not source inside settings"
        return ;
    }
    if ( -not($settings[3].contains('destination'))) {
        write-host "There is not destination inside settings"
        return ;
    }
    
    $fileName = $settings[0].split(' "='); 
    $date = $settings[1].split(' "=');   
    $source = $settings[2].split('"='); 
    $destination = $settings[3].split('"=');  
           
    [String[]]$returnedData = $fileName[7], $date[7], $source[5] , $destination[5]; 
  
    return $returnedData ;
}

function copySourceFilesToDestination ($sourceDir, $destinationDir, $fileName, $date) {
    $i = 0;
    Get-ChildItem $sourceDir -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object ($_) {
        $sourceFile = $_.FullName
       
        if ( ($sourceFile -like $fileName) -and ($_.LastWriteTime -ge (get-date $date)) ) { 
            $destinationFile = $destinationDir + $_.Name
          
            if (Test-Path $destinationFile) {
                
                while (Test-Path $destinationFile) {
                    $i += 1;
                    $destinationFile = $destinationDir + $_.basename + $i + $_.extension;                 
                }
            } 
            Copy-Item -Path $sourceFile -Destination $destinationFile -Verbose -Force
        }
    }
}

function updateFileDate($date, $settingsFilePath) {
    $oldDate = '<item key="date" value="' + $date + '" />' ;
    $today = Get-Date;
    $newDate = '<item key="date" value="' + $today.tostring('dd-MM-yyyy') + '" />' ;
    (Get-Content $settingsFilePath ) -replace $oldDate, $newDate | Set-Content $settingsFilePath;                        
}

mainScript ;