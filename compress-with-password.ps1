# This script will allow you to compress using 7Zip a defined file with password to enhance security.
# You'll need to have, of course, 7Zip installed on the Win64 machine.
# Also, you'll need to pass the directory, original filename and destination filename.

param([string]$directory = "www", [string]$original_file = "xxx", [string]$dest_file = "yyy")

# Edit here adding the password you want to use for the final file, as well as the compression level
[string] $zip_password = "wGW8K3dHhMvN2"
[string] $compression = "-mx9"

# This was taken from https://gist.github.com/jonschoning/5551567 with some minor tweaks.
function Write-ZipUsing7Zip([string]$FilesToZip, [string]$ZipOutputFilePath, [string]$Password, [ValidateSet('7z','zip','gzip','bzip2','tar','iso','udf')][string]$CompressionType = 'zip', [switch]$HideWindow) {
    # First, this will check if the 7zip file installation is correct. Please edit the root paths.
    if (-not(Test-Path ("C:\Users\home_user\zip\7z.exe"))) {
        throw "We couldn't find 7zip.exe."
    } elseif (-not(Test-Path ("C:\Users\home_user\zip\7z.dll"))) {
        throw "We couldn't find 7zip.dll."
    }
   
    # This will remove the final destination file if it does exist prior to the compression.
    if (Test-Path $ZipOutputFilePath) {
        Remove-Item $ZipOutputFilePath -Force
    }
    
    # This will make it to not prompt via GUI the 7z window.
    $windowStyle = "Normal"
    if ($HideWindow) {
        $windowStyle = "Hidden"
    }
    
    # This will save the different arguments: "a" for adding (compressing), and the compression format.
    $arguments = "a -t$compression ""$ZipOutputFilePath"" ""$FilesToZip"" $compression"
   
    # This will add the password to the prior arguments.
    if (!([string]::IsNullOrEmpty($zip_password))) {
        $arguments += " -p$zip_password"
    }

    $pathTo7ZipExe = ("C:\Users\home_user\zip\7z.exe")
    
    # And this will invoke the actual compression with the prior arguments.
    $p = Start-Process $pathTo7ZipExe -ArgumentList $arguments -Wait -PassThru -WindowStyle $windowStyle       

    # ... and a final check that it was correctly generated.
    if (!(($p.HasExited -eq $true) -and ($p.ExitCode -eq 0))) {
        throw ("We encountered errors while generating '$ZipOutputFilePath'.")
    }
}

# After this function definition, let's just run it with the "zip" extension and using the prior password.
cd $directory
Write-ZipUsing7Zip -FilesToZip $original_file -ZipOutputFilePath $dest_file -Password $zip_password -CompressionType zip -HideWindow $false
Remove-Item $original_file
