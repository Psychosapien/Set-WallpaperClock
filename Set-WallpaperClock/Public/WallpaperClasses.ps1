using namespace System.Drawing
using namespace System.Windows.Forms

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

Function Set-WallpaperClasses {

    $setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@

    Add-Type -TypeDefinition $setwallpapersrc

    $class = @"
    public class Num2Word
    {
        public static string NumberToText( int n)
          {
           if ( n < 0 )
              return "Minus " + NumberToText(-n);
           else if ( n == 0 )
              return "";
           else if ( n <= 19 )
              return new string[] {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", 
                 "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", 
                 "Seventeen", "Eighteen", "Nineteen"}[n-1] + " ";
           else if ( n <= 99 )
              return new string[] {"Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", 
                 "Eighty", "Ninety"}[n / 10 - 2] + " " + NumberToText(n % 10);
           else if ( n <= 199 )
              return "One Hundred " + NumberToText(n % 100);
           else if ( n <= 999 )
              return NumberToText(n / 100) + "Hundreds " + NumberToText(n % 100);
           else if ( n <= 1999 )
              return "One Thousand " + NumberToText(n % 1000);
           else if ( n <= 999999 )
              return NumberToText(n / 1000) + "Thousands " + NumberToText(n % 1000);
           else if ( n <= 1999999 )
              return "One Million " + NumberToText(n % 1000000);
           else if ( n <= 999999999)
              return NumberToText(n / 1000000) + "Millions " + NumberToText(n % 1000000);
           else if ( n <= 1999999999 )
              return "One Billion " + NumberToText(n % 1000000000);
           else 
              return NumberToText(n / 1000000000) + "Billions " + NumberToText(n % 1000000000);
        }
    }
"@

    Add-Type -TypeDefinition $class

}