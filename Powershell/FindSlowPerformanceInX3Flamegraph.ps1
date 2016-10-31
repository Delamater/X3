$myFlameGraph = "C:\temp\FlameGraphLog_SOEntry_ToLineSave.txt"
$threshold = 1000
$fileContent = Get-Content($myFlameGraph)

$counter = 0
foreach ($line in $fileContent)
{
    [System.Int32]$numerator = $counter+1
    [System.Int32]$denominator = $fileContent.Length + 1
    Write-Progress -Activity "Finding Slow Performance" -Status $counter -PercentComplete (($counter / $fileContent.Length) * 100)

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
                $ansiArtStart = "*" * 60 + " START" + "*" * 60
                $ansiArtEnd = "*" * 60 + " END  " + "*" * 60

                Write-Output $ansiArtStart
                $message = "Line #: " + $counter + " Tick Value: " + $ThisLoopTickValue.Value + " Tick Difference: " + [math]::Abs($ThisLoopTickValue.Value - $LastLoopTickValue.Value)
                Write-Output $message
                Write-Output "Statment: " $line
                Write-Output $ansiArtEnd

            }
        }

        $LastLoopTickValue = $ThisLoopTickValue

    }
    
 
    $counter += 1    
}
