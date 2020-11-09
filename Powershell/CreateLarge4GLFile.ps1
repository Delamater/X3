$fileDestination = "c:\temp\LargeFile.src"
function file-builder($fileName, $nTimes) {
$result = ""
    for ($i=0; $i -lt $nTimes; $i++){
        $result +="Funprog TESTCASE_$i`r`n"
        $result +="`r`n"
        $result +="   Local Char MESSAGE(250)`r`n"
        $result += "   MESSAGE=""This is a message""`r`n"
        $result += "   RET=0`r`n"
        $result += "`r`n"
        $result += "End RET`r`n"
        $result += "`r`n"

    }

    return $result

}



$retVal = ""
$retVal = file-builder -fileName "Some anem" -nTimes 5
Write-Host "result: $retVal" 
Out-File -FilePath $fileDestination -InputObject $retVal
