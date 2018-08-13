#requires -RunAsAdministrator

# Path set up
$source = "D:\WorkingFolder\runtime\vers\x64\*"
$dest = "C:\Sage\X3ERPV11\Runtime\bin\*"
$svc1 = Get-Service 'Agent Sage Syracuse - NODE0'
$svc2 = Get-Service X3ERPV11RUN
$allFiles = $true

#Stop service
Stop-Service -DisplayName $svc1.DisplayName
$svc1.WaitForStatus('Stopped')
Stop-Service -DisplayName $svc2.DisplayName
$svc2.WaitForStatus('Stopped')

Start-Sleep 2


#Clear files
Remove-Item -Path $dest -Recurse

switch ($allFiles)
{
    $true
    {
        # Copy files needed after the build
        # Remove asterisk at the end of the path
        Copy-Item -Destination $dest.Substring(0,$dest.Length-1) -Path $source -Recurse 
    }
    $false
    {
        # Copy files needed after the build
        Copy-Item -Filter "*.exe" -Destination $dest -Path $source -Recurse 
        Copy-Item -Filter "env.bat" -Destination $dest -Path "C:\Users\x3admin\Desktop\orig\*" -Recurse 
        Copy-Item -Filter "*.dll" -Destination $dest -Path $source -Recurse 
    }
}


#Start services and restart
Start-Service -DisplayName $svc1.DisplayName
Start-Service -DisplayName $svc2.DisplayName
