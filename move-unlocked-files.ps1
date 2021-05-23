# This script will allow you to move files from point A to B with an specific check that it's not being used by the system.
# It'll need the origin and destination full paths with filename as per CLI.

param([string]$orig = "xxx", [string]$dest = "yyy")

# This will show the parameter files sent via CLI for debug.
Write-Host "Origen: $orig"
Write-Host "Destino: $dest"

# This function was taken from shorturl.at/lJS28 with some tweaks.
Function Wait-FileUnlock{
    Param(
        [Parameter()]
        [IO.FileInfo]$File,
        [int]$SleepInterval=1000 # Interval to check
    )
    while(1){
        try{
           $fs=$file.Open('open','read', 'Read')
           $fs.Close()
            Write-Verbose "$file not open"
            Write-Host "Use control: $file not in use"
           return
           }
        catch{
           Start-Sleep -Milliseconds $SleepInterval
           Write-Verbose '-'
           Write-Host "Use control: $file in use. Waiting."
        }
	}
}

# Let's wait until the file is freed-up;
Wait-FileUnlock (Get-ChildItem $orig | % { $_.FullName })

# ... and grab the original name of the file (complete)
$orig_name = Get-ChildItem $orig | % { $_.Name }

# ... and let's move the file forcing the writing on the destination.
Move-Item -Path $orig -Destination $dest -Force

# Once moved, let's grab the full path+name of the file once moved...
$dest_folder = (Get-Item $dest).FullName

# And we'll make a quick test to verify that it was correctly moved and exists.
if (Test-Path ($dest_folder + $orig_name) ) {
    Write-Host "Movement Control: $orig_name correctly moved to $dest_folder"
} else {
    Write-Host "Movement Control: Error while moving $orig_name to $dest_folder"
}
