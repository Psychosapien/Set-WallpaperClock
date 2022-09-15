using namespace System.Drawing
using namespace System.Windows.Forms

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

function Set-WallpaperClock {

    <#
        .SYNOPSIS
        This function randomly generates and applies a desktop wallpaper, based on the current time.
        It has several available flavours, to suit many needs.
        The function can also tie into Azure DevOps (ADO) to get current work information.
        .DESCRIPTION
        With the most basic iteration of this function, your desktop wallpaper will be replaced with a black background that displays the time and a nice greeting.
        Admin rights are required for this to run properly. So make sure to run the function from an elevated shell.
        Note that using the -sweary option can sometimes result in quite rude words being on your screen. So use at your discretion.
        Konnecting this function to ADO is achieved by using the New-ADOCredential cmdlet and entering the details specified within its help file.
        .PARAMETER withQuote
            This switch will add a randomly generated quote to your wallpaper. This is possibly the best feature of this function.
        .PARAMETER showDevOpsInfo
            This will make an API call to your DevOps instance and will then record information about work items in the current sprint on the wallpaper.
            This is good for impressing people.
        .PARAMETER Sweary
            This will change the text on the wallpaper to include swear words. This is lots of fun but don't use it if your boss is a swear word.
    #>
    [CmdletBinding()]
    param (

        [switch]$withQuote,
        [switch]$showDevOpsInfo,
        [switch]$Sweary

    )

    begin {


        #Get public and private function definition files.
        $Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

        #Dot source the files
        Foreach ($import in @($Public)) {
            Try {
                . $import.fullname
            }
            Catch {
                Write-Error -Message "Failed to import function $($import.fullname): $_"
            }
        }

        if ($showDevOpsInfo -eq $true) {

            $Creds = . "$PSScriptRoot\Private\ADO-Creds.ps1"
            $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($Creds.patToken)"))
            $header = @{authorization = "Basic $($Token)" }

            $ADO = Get-AzureDevOps -patToken $Creds.patToken -organizationName $Creds.organizationName -projectName $Creds.projectName -userFullName $Creds.userFullName -userPrincipalName $Creds.userPrincipalName

        }

        Set-WallpaperClasses

        $timeText = Get-Timetext

        $ProgressPreference = 'SilentlyContinue'

        $path = (Get-ChildItem -Path C:\Windows\Personalization\DesktopImage).FullName

        if (-not $path) {
            $path = "%AppData%\Microsoft\Windows\Themes\TranscodedWallpaper"
        }

        $d = Get-Date
        $suffix = Get-DateOrdinalSuffix $d
        $dateFormatted = "{0} the {2}{3} of {1:MMMM} - {4}" -f $d.DayOfWeek, $d, $d.Day, $suffix, $d.Year

        $Quote = Get-Quote

        $TimeSuffix = @(
            "roughly"
            "approximately"
            "pretty much"
            "basically"
            "essentially"
            "probably"
            "most likely"
            "kind of"
            "more or less"
            "practically"
            "somewhere around"
            "pretty near"
            "mostly"
        )

        $Firstword = Get-Word -Type KindAdjective
    }

    process {


        if (-not $sweary) {

            $lines = "



            $(if ((get-date -Format "dddd") -eq "Wednesday") {
                "It is Wednesday, my dude."
            } else {
                "It is $dateformatted"
            })

            The time is $( get-random $TimeSuffix ) $timetext
            $(if ($withQuote){"
                $('#' * (5 + ($quote | Measure-Object -Character).Characters))
                #  Quote of the day:$(' ' * (($quote | Measure-Object -Character).Characters - 16))#
                #  $($Quote) #
                $('#' * (5 + ($quote | Measure-Object -Character).Characters))
                "

            })
            $(if ($ADO) {
                "You currently have $(($ADO).count) tickets in DevOps...`n"

                $(if(($ADO).count -lt 20) {
                    Foreach ($item in $ADO) {
                    "`t`t#";$item; "-"
                            $UriOrga = "https://dev.azure.com/$($Creds.OrganizationName)/$($Creds.projectName)/_apis/wit/workitems/$($item)?api-version=6.0"
                            $Results= Invoke-RestMethod -Uri $UriOrga -Method Get -ContentType "application/json" -Headers $header
                            if (($Results.fields.'System.Title').Length -gt 90) {
                                ($Results.fields.'System.Title').insert(90,"-`n            -")
                            } else {
                                $Results.fields.'System.Title'
                            }
                            "`r`n"
                        }
                    } else {
            "
            That's too many things to display here, just do some work.
            "
                    })
                })
            I hope you have $(Get-PrefixAorAn $Firstword) $firstword $(Get-Word Adjective) day.
        "
        }
        else {

            $lines = "



            $(if ((get-date -Format "dddd") -eq "Wednesday") {
                "It is Wednesday, you $(Get-Word swear)."
            } else {
                "It is $dateformatted"
            })

            The time is $( get-random $TimeSuffix ) $timetext

            $(if ($withQuote){"
                $('#' * (5 + ($quote | Measure-Object -Character).Characters))
                #  Quote of the day:$(' ' * (($quote | Measure-Object -Character).Characters - 16))#
                #  $($Quote) #
                $('#' * (5 + ($quote | Measure-Object -Character).Characters))
                "
            })

            $(if ($ADO) {
                "You currently have $(($ADO).count) $(Get-Plural (Get-word Swear)) in DevOps...`n"

                $(if(($ADO).count -lt 20) {
                Foreach ($item in $ADO) {
                "`t`t#";$item; "-"
                        $UriOrga = "https://dev.azure.com/$($Creds.OrganizationName)/$($Creds.projectName)/_apis/wit/workitems/$($item)?api-version=6.0"
                        $Results= Invoke-RestMethod -Uri $UriOrga -Method Get -ContentType "application/json" -Headers $header
                        if (($Results.fields.'System.Title').Length -gt 90) {
                            ($Results.fields.'System.Title').insert(90,"-`n            -")
                        } else {
                            $Results.fields.'System.Title'
                        }
                        "`r`n"
                    }
                } else {
            "
            That's too many things to display here, just do some work.
            "
                })
            })
            I hope you have $(Get-PrefixAorAn $Firstword) $firstword $(Remove-Plural (get-word swear)) day.
        "
        }
    }

    end {

        export-png -InputObject $lines -Path $path
        [Wallpaper]::SetWallpaper($path)
    }
}

Function New-ADOCredential {
    <#
        .SYNOPSIS
        This function allows you to store your DevOps information to use with the Set-WallpaperClock function.
        .DESCRIPTION
        Connecting to Azure DevOps (ADO) requires a PAT token, so please follow these instructions to get one > https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
        Using this function will store your information in a file alongside the module, on your local machine. No data is tranferred away from your machine.
        Make sure you include the correct information for each param. If you need to update your PAT token in future, use the Update-PatToken function.
        .PARAMETER patToken
            This will be your generated PAT token from ADO
        .PARAMETER organizationName
            This is the Org name for your ADO instance.
            I.E: https://dev.azure.com/$organizationName
        .PARAMETER projectName
            Surprise, surprise - this is the name of your ADO project.
            I.E: https://dev.azure.com/$organizationName/$projectName
        .PARAMETER userFullName
            This should just be your full name as it appears in ADO.
        .PARAMETER userPrincipalName
            This should be your email as it appears in ADO.


    #>
    Param
    (
        [string]$patToken,
        [string]$organizationName,
        [string]$projectName,
        [string]$userFullName,
        [string]$userPrincipalName
    )

    $CredPath = "$PSScriptRoot\Private\ADO-Creds.ps1"

    $Creds = Get-content -path $CredPath

    $Creds -replace "__patToken__", "'$patToken'"`
        -replace "__organizationName__", "'$organizationName'"`
        -replace "__projectName__", "'$projectName'"`
        -replace "__userFullName__", "'$userFullName'"`
        -replace "__userPrincipalName__", "'$userPrincipalName'" | Set-Content $CredPath
}

Function Update-ADOPATToken {
    Param
    (
        [string]$patToken
    )

    $CredPath = "$PSScriptRoot\Private\ADO-Creds.ps1"

    $Creds = Get-content -path $CredPath

    $pattern = [regex]::Escape(($Creds[0] | select-string -Pattern "`'\s*(.*?)\s*`'").matches.value)

    $Creds -replace $pattern, "$patToken" | Set-Content $CredPath

}