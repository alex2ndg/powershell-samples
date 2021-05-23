# This script will allow you to decompress any specific zip files with password using 7zip.
# You'll need to pass via CLI the destination directory in where the files are.

param([string]$final_dir = "yyy")

# Please append here the defined password you need to use.
[string] $password = "askjhP9SIDj"

# We'll list all of the compressed files...
cd $final_dir
$files = Get-ChildItem $final_dir\*.zip

# ... and for each of those files, we'll decompress them using 7zip.
ForEach ($file in $files) { 
	$7ZipPath = '"C:\Users\home_user\zip\7z.exe"'
	$command = "& $7ZipPath e -o$final_dir -y -tzip -p'$password' $file"
	iex $command
}
