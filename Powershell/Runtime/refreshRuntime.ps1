# Variable set up
$buildDir = "C:\ghub\runtime\vers\x64\*"
$runtimeDir = "C:\Sage\EMV12\Runtime\bin\*"
$serviceName = Get-Service -Name "EMV12RUN"

# Stop down service
Stop-Service -DisplayName $serviceName.DisplayName
$serviceName.WaitForStatus("Stopped")

#Start-Sleep 2

# Kill all adonix.exe
taskkill /IM adonix.exe /F


# Copy from build directory to running directory
Copy-Item -Destination $runtimeDir.Substring(0,$runtimeDir.Length-1) -Path $buildDir -Recurse 

# Restart service
Start-Service -DisplayName $serviceName.DisplayName
