#------------------------------------------------------
# Set default Value
#------------------------------------------------------
    $RETURN_VALUE = 0
    $RETURN_TEXT = ""

#------------------------------------------------------    
# Check Script Path
#------------------------------------------------------
    if ($RETURN_VALUE -eq 0){
        # for PS v3
        if( $PSVersionTable.PSVersion.Major -ge 3 ){
            $ScriptDir = $PSScriptRoot
            Write-Host "Start rotation......"
            Start-Sleep 1
        }
        # for PS v2
        else{
            $ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
            Write-Host "Start rotation......"
            Start-Sleep 1
        }
    }
    # Write-Host $ScriptDir

#------------------------------------------------------
# Set file path
#------------------------------------------------------
    if ($RETURN_VALUE -eq 0){
        # Orginal file folder
        $sourceFolderPath = $ScriptDir

        # dest folder path
        $destinationFolderPath = "$SCRIPT_DIR\0.0 old\Log Backup\"

        # Get date
        $currentDate = Get-Date

        # Get file list
        $files = Get-Item -Path $sourceFolderPath | Get-ChildItem -File

        # Get TimeStamp
        $TIMESTAMP = (Get-Date).ToString("yyyyMMddHHmmss")

        $LOG_DIR = "$sourceFolderPath\"

        $LOG_NAME = "$TIMESTAMP.log"

        $LOG_FILE_FULLPATH = "$LOG_DIR" + "$LOG_NAME"

        Start-Sleep 3
    }

#------------------------------------------------------
# Check Log path and Log file
#------------------------------------------------------
    if ($RETURN_VALUE -eq 0){
        # Check if log path exist
        if (!(Test-Path $LOG_DIR)) {
            # Write a error message when the path not exist.
            $RETURN_TEXT = "Script Log Directory not found.(Directory: $LOG_DIR)"
            $RETURN_VALUE = 12

        } 
    }
    if ($RETURN_VALUE -eq 0){
        if(!(Test-Path $LOG_FILE_FULLPATH)){
            # Create a new log file.
            New-Item -ItemType file -Path $LOG_FILE_FULLPATH -Force
            # Write a message when the log file created.
            Write-Host "New log file created.(File name: $LOG_NAME)"
            Start-Sleep 3
        } 
    }

#------------------------------------------------------
# Check file list, if no files need move
#------------------------------------------------------
    if ($RETURN_VALUE -eq 0){
        # Create a list to save file which need move
        $filesToMove = @()

        # Check file in files
        foreach ($file in $files) {
            # Check last write time
            if ($file.Extension -eq ".log") {
                # Move file from list
                $filesToMove += $file
        
            }
        }

        # Check if no file need to move
        if ($filesToMove.Count -eq 0) {
            Write-Host "No file need move. Finish......"
            $RETURN_VALUE = 8
            $RETURN_TEXT = "No file need move"
            Add-Content -Path $LOG_FILE_FULLPATH -Value "[$(get-date -f yyyy/MM/dd-HH:mm:ss.fff)] [WARN] $RETURN_TEXT"
            Start-Sleep 3
        }
    }

#------------------------------------------------------
# Start Move files #
#------------------------------------------------------
    if ($RETURN_VALUE -eq 0){
        # define dest folder
        $destinationDateFolder = Join-Path -Path $destinationFolderPath -ChildPath $currentDate.ToString("yyyyMMdd")
        # If not exist, Create
        if (-not (Test-Path -Path $destinationDateFolder)) {
            New-Item -ItemType Directory -Path $destinationDateFolder
        }

        foreach ($fileToMove in $filesToMove) {
            # Define dest folder path
            $destinationFilePath = Join-Path -Path $destinationDateFolder -ChildPath $fileToMove.Name
            # Move
            Move-Item -Path $fileToMove.FullName -Destination $destinationFilePath
            Write-Host "Move $($fileToMove.FullName) to $($destinationFilePath)"
            Add-Content -Path $LOG_FILE_FULLPATH -Value "[$(get-date -f yyyy/MM/dd-HH:mm:ss.fff)] [INFO] Move $($fileToMove.Name) to $($destinationFilePath)"
            # Sleep
            Start-sleep 3
        }
    }

#------------------------------------------------------
# End of processing
#------------------------------------------------------
    Write-Host "Finish. Press any to exit."
    Pause
    
