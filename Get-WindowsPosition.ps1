Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class WindowHelper
{
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hwnd, out RECT lpRect);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr GetDesktopWindow();
}

[StructLayout(LayoutKind.Sequential)]
public struct RECT
{
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

function Get-WindowsPosition {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    process {
        foreach ($window in (Get-Process -Name $Name -ErrorAction SilentlyContinue).MainWindowHandle) {
            if ($window -ne [IntPtr]::Zero) {
                $windowRect = New-Object RECT

                [WindowHelper]::GetWindowRect($window, [ref]$windowRect) | Out-Null

                $position = @{
                    "Name"               = $Name
                    "Left"               = $windowRect.Left
                    "Top"                = $windowRect.Top
                    "Width"              = $windowRect.Right - $windowRect.Left
                    "Height"             = $windowRect.Bottom - $windowRect.Top
                    "Display"            = $null
                }

                $screens = [System.Windows.Forms.Screen]::AllScreens
                foreach ($s in $screens) {
                    if ($s.Bounds.Contains($windowRect.Left, $windowRect.Top)) {
                        $position["Display"] = $s.DeviceName
                        break
                    }
                }

                if ($null -eq $position["Display"]) {
                    $desktopWindow = [WindowHelper]::GetDesktopWindow()
                    $screen = [System.Windows.Forms.Screen]::FromHandle($desktopWindow)
                    $position["Display"] = $screen.DeviceName
                }

                $obj = New-Object -TypeName PSObject -Property $position
                Write-Output $obj
            }
        }
    }
}