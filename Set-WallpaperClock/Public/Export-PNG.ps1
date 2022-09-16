function Export-Png {
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [string[]]$InputObject,

        # Path where output image should be saved
        [string]$Path
    )

    begin {
        # can render multiple lines, so $lines exists to gather
        # all input from the pipeline into one collection
        [Collections.Generic.List[String]]$lines = @()
    }
    Process {
        # each incoming string from the pipeline, works even
        # if it's a multiline-string. If it's an array of string
        # this implicitly joins them using $OFS
        $null = $lines.Add($InputObject)
    }

    End {
        # join the array of lines into a string, so the 
        # drawing routines can render the multiline string directly
        # without us looping over them or calculating line offsets, etc.
        [string]$lines = $lines -join "`n"


        # placeholder 1x1 pixel bitmap, will be used to measure the line
        # size, before re-creating it big enough for all the text
        [Bitmap]$bmpImage = [Bitmap]::new(1, 1)

        # Create the Font, using any available MonoSpace font
        # hardcoded size and style, because it's easy
        #[Font]$font = [Font]::new([FontFamily]::("Major Mono Display"), 72, [FontStyle]::Regular, [GraphicsUnit]::Pixel)

        [Font]$Font = [Font]::new(
            "Consolas", 
            30, 
            [FontStyle]::Regular, 
            [GraphicsUnit]::Pixel
        )
        
        # Recreate the bmpImage big enough for the text.
        # and recreate the Graphics context from the new bitmap

        Add-Type -AssemblyName System.Windows.Forms

        $display =  [System.Windows.Forms.Screen]::AllScreens
        $BmpImage = [Bitmap]::new($display[0].bounds.size.width, $display[0].bounds.size.height)
        $Graphics = [Graphics]::FromImage($BmpImage)


        # Set Background color, and font drawing styles
        # hard coded because early version, it's easy
        $Graphics.Clear([Color]::Black)
        $Graphics.SmoothingMode = [Drawing2D.SmoothingMode]::Default
        $Graphics.TextRenderingHint = [Text.TextRenderingHint]::SystemDefault
        $brushColour = [SolidBrush]::new([Color]::FromArgb(200, 200, 200))


        # Render the text onto the image
        $Graphics.DrawString($lines, $Font, $brushColour, 0, 0)

        $Graphics.Flush()

        # Export image to file
        [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
        $Path = [System.IO.Path]::GetFullPath($Path)
        $bmpImage.Save($Path, [Imaging.ImageFormat]::Png)
    }

}
