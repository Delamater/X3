$myFlameGraph = "C:\temp\FlameGraphLog_SOEntry_ToLineSave.txt"
$threshold = 250
$fileContent = Get-Content($myFlameGraph)

#Select-String -Path $myFlameGraph -Pattern "tick:" -AllMatches -SimpleMatch -List

$counter = 0
foreach ($line in $fileContent)
{
    [System.Int32]$numerator = $counter+1
    [System.Int32]$denominator = $fileContent.Length + 1
    Write-Progress -Activity "Finding Slow Performance" -Status "AAA" -PercentComplete (($counter / $fileContent.Length) * 100)

    $JustAfterTick = [regex]::Match($line, "tick").Index + 5
    $regExResult = [regex]::Match($line,"tick")
    if ($regExResult.Success)
    {
        $JustAfterTick = $regExResult.Index + 5
        $someString = $line.Substring($JustAfterTick)
        $ThisLoopTickValue= [regex]::Match($someString, "\d{1,10}")


        if ($counter -gt 0)
        {
            if ([math]::Abs($ThisLoopTickValue.Value - $LastLoopTickValue.Value) -ge $threshold)
            {
                $message = "Line #: " + $counter + " Tick Value: " + $ThisLoopTickValue.Value + " Tick Difference: " + [math]::Abs($ThisLoopTickValue.Value - $LastLoopTickValue.Value)
                Write-Output $message
            }
        }

        $LastLoopTickValue = $ThisLoopTickValue

    }
    
 
    $counter += 1    
}
