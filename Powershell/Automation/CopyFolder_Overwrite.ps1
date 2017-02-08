#Author: Bob Delamater
#Date: 02/08/2017
#Description: Copy folder down from one location to another, overwrite. 

$SourceFolder = "Q:\X3V11_P-FLOW-GESPIH-TWM-05"
$TargetFolder = "C:\WorkingFolder\X3\Automation\Scripts"

$CopyResult = Copy-Item -Path $SourceFolder -Destination $TargetFolder -Recurse -Container -Force
if(-not $?) {write-warning "Copy Failed"}
