# This script will allow you to decipher via PGP any specific file, using the defined already installed keys.
# It'll need the original directory of the file, original file name and output of the file.

param([string]$dir = "www", [string]$ofile = "xxx", [string]$ffile = "zzz")

Write-Host "Directory: $dir"
Write-Host "Original File: $ofile"
Write-Host "Final File: $ffile"

# You'll have to define the --home-dir just in case if the user you are using doesn't has the keyring defined properly
# Passphrase is optional - on this sample we are using a blank space. 
# You can remove -s flag if you don't want to sign the file (some clients would prefer it like so)
cd $dir
pgp --home-dir "C:\Users\my_user\PGP" --decrypt $ofile --output $ffile --passphrase " "
Remove-Item $ofile

# If you want to preseve the original filename, try using something like the following loop.
# Take for example that we want to decipher all XML.pgp files on an specific directory:
cd $dir
$files = Get-ChildItem $dir\*.xml.pgp
# For all of the $files we'll save a $foutput to save the original filename w/o extension.
ForEach ($file in $files) { 
	$foutput = $file.Name -replace ".xml.pgp", ".xml"
	pgp --home-dir "C:\Users\my_user\PGP" --decrypt $ofile --output $foutput
	Remove-Item $ofile
}
