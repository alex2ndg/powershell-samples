# This script will allow you to cipher via PGP any specific file, using the defined already installed keys.
# It'll need the original directory of the file, original file name, PGP key and output of the file.

param([string]$dir = "www", [string]$ofile = "xxx", [string]$key = "yyy", [string]$ffile = "zzz")

Write-Host "Directory: $dir"
Write-Host "Original File: $ofile"
Write-Host "Key: $key"
Write-Host "Final File: $ffile"

# You'll have to define the --home-dir just in case if the user you are using doesn't has the keyring defined properly
# Passphrase is optional - on this sample we are using a blank space. 
# You can remove -s flag if you don't want to sign the file (some clients would prefer it like so)
cd $dir
pgp --home-dir "C:\Users\my_user\PGP" -e $ofile -r $key -s --output $ffile --passphrase " "
Remove-Item $entrada
