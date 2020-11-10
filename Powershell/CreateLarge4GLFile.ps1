$fileDestination = "c:\temp\LargeFile.src"
#$envOptions = "`n" #"`r`n"
$envOptions = environment::newline
$nTimes = 2
$runtimePath = "D:\Sage\X3ERPV12\Runtime"
$cmd = "valtrt -v -l ""ENG"" -f %ADXDIR%/../Folders/X3/TRT/ZLARGE01 -d %ADXDIR%/../Folders/X3/TRT"
$combinedPath = "$envBat;$cmd"


function Get-Environment-Script{
    <#
        .SYNOPSIS
            Return the path to the env.bat file. Test to ensure that the path is valid.
        .INPUTS
            runtimePath: The full path of Runtime (ADXDIR), such as C:\Sage\EMV12\Runtime.
        .OUTPUTS
            envBatPath: The full path of Runtime env.bat file (should be ADXDIR\bin)
    #>
    param(
        [Parameter(Mandatory = $true, Position = 1)] [string] $runtimePath
    )

    $envBatPath = Join-Path -Path "$runtimePath" -ChildPath "bin" | Join-Path -ChildPath "env.bat"
    #Test-FileOrDir-EXIST -DIRorFILE $envBatPath

    return $envBatPath
}

# Execute a system command
# Return a structure which includes stderr and stdout 
function Invoke-Command ($commandTitle, $commandPath, $commandArguments) {
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $commandPath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $commandArguments
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    [pscustomobject]@{
        commandTitle = $commandTitle
        stdout       = $p.StandardOutput.ReadToEnd()
        stderr       = $p.StandardError.ReadToEnd()
        ExitCode     = $p.ExitCode
    }
}

function file-builder($nTimes) {
$result = ""
    for ($i=0; $i -lt $nTimes; $i++){
        $result +="Funprog TESTCASE_$i $envOptions"
        $result +="`r`n"
        $result +="   Local Char MESSAGE(250) $envOptions"
        $result += "   MESSAGE=""This is a message"" $envOptions"
        $result += "   RET=$i $envOptions"
        $result += $envOptions
        $result += "End RET $envOptions"
        $result += $envOptions

    }

    return $result

}





$retVal = file-builder -nTimes $nTimes 
Out-File -FilePath $fileDestination -InputObject $retVal -Encoding utf8
#Copy-Item -Path $fileDestination -Destination "$runtimePath/../folders/X3/TRT/ZLARGE05.src"

#$envBat = Get-Environment-Script -runtimePath $runtimePath
#Invoke-Command -commandTitle "VALTRT" -commandPath "cmd" -commandArguments "/c " + $envBat + " " + $cmd 

#valtrt -v -l "ENG" -f %ADXDIR%/../Folders/X3/TRT/LargeFile -d %ADXDIR%/../Folders/X3/TRT
