#Author: Bob Delamater
#Date: 02/08/2017
#Description: Copy folder down from one location to another, overwrite. 

$SourceFolder = Read-Host -Prompt "Path to test:" 
#$SourceFolder = "\X3VNEXT_M-FLOW-GESMFG-PS-3"
$FullPathSourceFolder = "Q:\" + $SourceFolder
$TargetFolder = "C:\Users\bdelamater\Google Drive\Sage\X3\WorkingFolder\Automation\Scripts"

#$CopyResult = Copy-Item -Path $FullPathSourceFolder -Destination $TargetFolder -Recurse -Container -Force
#if(-not $?) {write-warning "Copy Failed"}


# Check local file list, look for the number of iterations
$files = Get-ChildItem $TargetFolder\$SourceFolder -Filter *IT*.htm

$iterationValues = New-Object System.Collections.Generic.List[System.Object]

foreach ($file in $files){
    $startPos =$file.ToString().IndexOf("_IT")
    $iterationValues.Add( $file.ToString().SubString($startPos+3,1) )
}

$iterationValues|measure -Maximum


#Cleanup
$iterationValues.Clear()
