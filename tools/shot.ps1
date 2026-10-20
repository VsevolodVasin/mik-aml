Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class WinShot {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc lp, IntPtr l);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
  public struct RECT { public int L, T, R, B; }
}
"@
$sb = New-Object System.Text.StringBuilder 512
$hits = New-Object System.Collections.Generic.List[string]
[WinShot]::EnumWindows({
  param($h, $l)
  if (-not [WinShot]::IsWindowVisible($h)) { return $true }
  [void][WinShot]::GetWindowText($h, $sb, $sb.Capacity)
  $t = $sb.ToString()
  if ($t.Length -gt 0) {
    $r = New-Object WinShot+RECT
    [void][WinShot]::GetWindowRect($h, [ref]$r)
    $line = "{0}|{1}|{2}|{3}|{4}" -f $t, $r.L, $r.T, ($r.R-$r.L), ($r.B-$r.T)
    $hits.Add($line)
  }
  return $true
}, [IntPtr]::Zero) | Out-Null
$hits | Set-Content -Encoding UTF8 C:\Khadas\windows.txt
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$bmp.Save("C:\Khadas\screen.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
"saved $($hits.Count)" | Set-Content C:\Khadas\shot_ok.txt
