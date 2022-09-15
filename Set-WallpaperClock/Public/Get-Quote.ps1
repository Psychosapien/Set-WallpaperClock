
# Set the progress pref for webrequests

$progresspreference = "silentlyContinue"

# All of the functions
function Get-PrefixAorAn {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -ne "s" -or $word.Substring($word.Length - 2) -eq "ss") {
        if ($word[0] -eq "a" `
                -or $word[0] -eq "e" `
                -or $word[0] -eq "i" `
                -or $word[0] -eq "o" `
                -or $word[0] -eq "u" `
                -and $word.Substring(0, 2) -ne "us" `
                -and $word.Substring(0, 2) -ne "un") { "an" } `
            else { "a" }
    }
}
function Get-PrefixIsorAre {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -ne "s") { "is" } `
        else { "are" }
}
function Get-PrefixItorThey {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -ne "s") { "it" } `
        else { "they" }
}
function Get-PrefixItorThem {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -ne "s") { "it" } `
        else { "them" }
}
function Get-Verber {
    param (
        [string]$word
    )
    if ($word.Substring($word.Length - 2) -eq "er") { "$($word)" } `
        elseif ($word[$word.length - 1] -eq "n") { "$($word)ner" }
    elseif ($word[$word.Length - 1] -ne "e") { "$($word)er" } `
        else { "$($word)r" }
}
function Get-Verbing {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -ne "e") { "$($word)ing" } else { "$($word.Trimend("e"))ing" }
}
function Get-PastTense {
    param (
        [string]$word
    )
    if ($word.Substring($word.Length - 2) -eq "ed") { "$($word)" } `
        elseif ($word.Substring($word.Length - 2) -eq "de") { "$($word)" } `
        elseif ($word[$word.Length - 1] -ne "e") { "$($word)ed" } `
        elseif ($word.Substring($word.Length - 3) -eq "ive") { "$($word.Replace("ive","ave"))" } `
        else { "$($word)d" }
}
function Get-Plural {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -eq "s") { "$($word)" } `
        elseif ($word[$word.Length - 1] -eq "y") { "$($word.TrimEnd("y"))ies" } `
        elseif ($word[$word.Length - 1] -ne "s") { "$($word)s" }
}
function Remove-Plural {
    param (
        [string]$word
    )
    if ($word[$word.Length - 1] -eq "s" -and $word.Substring($word.Length - 2) -ne "ss") { "$($word.TrimEnd("s"))" } `
        else { "$word" }
}
function Get-Word {
    param (
        [ValidateSet("Kind", "KindAdjective", "Verb", "Noun", "Adjective", "Person", "Swear")]
        [string]$Type
    )
    if ($Type -eq "Kind") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Kindness.txt).split(",") -replace "`r`n", "" | Select-String -Pattern ".*(?<!y)$"
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "KindAdjective") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Kindness.txt).split(",") -replace "`r`n", "" | Select-String -Pattern "ly$"
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "verb") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Verbs.txt).split(",") -replace "`r`n", "" | Select-Object -Unique
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "noun") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Nouns.txt).split(",") -replace "`r`n", "" | Select-Object -Unique
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "adjective") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Adjectives.txt).split(",") -replace "`r`n", "" | Select-Object -Unique
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "Person") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/People.txt).split(",") -replace "`r`n", "" | Select-Object -Unique
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
    Elseif ($Type -eq "swear") {
        $Wordlist = (Get-Content $PSScriptRoot/WordLists/Swears.txt).split(",") -replace "`r`n", "" | Select-Object -Unique
        $word = Get-Random -InputObject $Wordlist -SetSeed ([int32](Get-Date).Ticks.ToString().Substring(9))
        $word
    }
}

Function Get-Quote {

    [CmdletBinding()]
    # Set up required variables for the quotes
    $Swear = Get-Word -Type Swear
    $Verb = Get-Word -Type Verb
    $Adjective = Get-Word -Type Adjective
    $noun = Get-Word -Type Noun
    $person = Get-Word -Type Person

    # Create the list of quotes
    $Quotes = Get-Content $PSScriptRoot/quotes.txt

    # Make sure there are no double "" in the quote list (had problems with this)
    $Quotes = $quotes.Replace('""', '"')

    # Choose the quote to use
    $ChosenQuote = get-random $Quotes

    # Set the quote as a scriptblock so it can be executed
    $ScriptBlock = [scriptblock]::Create($ChosenQuote)

    # Run the scriptblock to finally create the quote
    $PreparedQuote = Invoke-Command $scriptblock

    # Build the final quote
    $FinalQuote = "$($PreparedQuote) -$person"

    $FinalQuote
}