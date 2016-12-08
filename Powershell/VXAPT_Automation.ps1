add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms
start-sleep -Milliseconds 500

function Click-MouseButton
{
param(
[string]$Button, 
[switch]$help)
$HelpInfo = @'

Function : Click-MouseButton
By       : John Bartels
Date     : 12/16/2012 
Purpose  : Clicks the Specified Mouse Button
Usage    : Click-MouseButton [-Help][-Button x]
           where      
                  -Help         displays this help
                  -Button       specify the Button You Wish to Click {left, middle, right}

'@ 

if ($help -or (!$Button))
{
    write-host $HelpInfo
    return
}
else
{
    $signature=@' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 


    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 
    if($Button -eq "left")
    {
        $SendMouseClick::mouse_event(0x00000002, 1802, 1003, 0, 0);
        $SendMouseClick::mouse_event(0x00000004, 1802, 1003, 0, 0);
    }
    if($Button -eq "right")
    {
        $SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0);
    }
    if($Button -eq "middle")
    {
        $SendMouseClick::mouse_event(0x00000020, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000040, 0, 0, 0, 0);
    }

}


}
$SleepTime = 500
[Microsoft.VisualBasic.Interaction]::AppActivate(8596)
For ($i = 0; $i -le 500; $i++)
{	
	[System.Windows.Forms.SendKeys]::SendWait(“W006074”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{TAB}”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait("{F12}")
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{ENTER}”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait("1")
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{TAB}”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{TAB}”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{TAB}”)
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait("{F12}")
	start-sleep -Milliseconds $SleepTime
	[System.Windows.Forms.SendKeys]::SendWait(“{ENTER}”)

	start-sleep -Milliseconds 1000

	$Position = [System.Windows.Forms.Cursor]::Position 
	$Position.X = 1802
	$Position.Y = 1003
	[System.Windows.Forms.Cursor]::Position = $Position
	
	Click-MouseButton "left"

	start-sleep -Milliseconds 10000

	[System.Windows.Forms.SendKeys]::SendWait(“{ENTER}”)
}
