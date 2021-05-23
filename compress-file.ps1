# This script will compress all files defined on a specific folder, and then will remove them.
# It'll need to have the folder (full path) and zip name that you desire added via CLI.

param([string]$folder = "xxx", [string]$zip = "yyy")

# This will show via stdout the folder & zip names for debug.
Write-Host "Carpeta: $folder"
Write-Host "ZIP: $zip"

# This will go recursively through all folders inside of the parent one except for a "proc" one (as per processed) if needed.
# For each folder, it'll grab the real directoy name and compress the files.
Get-ChildItem $folder -Recurse | ? { $_.PSIsContainer } | ? { $_.FullName -notmatch 'proc' } | ForEach-Object {
	$directoryName = $_.FullName
	cd $directoryName
  Invoke-Expression -Command "zip $folder\$zip *.*"
  Remove-Item $directoryName\*.*
}
