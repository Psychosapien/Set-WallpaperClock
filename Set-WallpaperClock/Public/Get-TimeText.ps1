function Get-TimeText {

    [int]$hournum = (get-date).hour
    if ($hournum -gt 12) { $hournum = $hournum - 12 }

    [int]$minutenum = (get-date).minute
    if (($minutenum -ge 55) -and ($minutenum -lt 60)) { $timetext = "$([Num2Word]::NumberToText($hournum+1))o'clock" }
    if (($minutenum -ge 53) -and ($minutenum -lt 56)) { $timetext = "five to $([Num2Word]::NumberToText($hournum+1))" }
    if (($minutenum -ge 48) -and ($minutenum -lt 53)) { $timetext = "ten to $([Num2Word]::NumberToText($hournum+1))" }
    if (($minutenum -ge 43) -and ($minutenum -lt 48)) { $timetext = "quarter to $([Num2Word]::NumberToText($hournum+1))" }
    if (($minutenum -ge 35) -and ($minutenum -lt 43)) { $timetext = "twenty to $([Num2Word]::NumberToText($hournum+1))" }
    if (($minutenum -ge 33) -and ($minutenum -lt 38)) { $timetext = "five and twenty to $([Num2Word]::NumberToText($hournum+1))" }
    if (($minutenum -ge 55) -and ($minutenum -lt 60) -and ($hournum -eq 12)) { $timetext = "$([Num2Word]::NumberToText(1))o'clock" }
    if (($minutenum -ge 48) -and ($minutenum -lt 55) -and ($hournum -eq 12)) { $timetext = "ten to $([Num2Word]::NumberToText(1))" }
    if (($minutenum -ge 43) -and ($minutenum -lt 48) -and ($hournum -eq 12)) { $timetext = "a quarter to $([Num2Word]::NumberToText(1))" }
    if (($minutenum -ge 38) -and ($minutenum -lt 43) -and ($hournum -eq 12)) { $timetext = "twenty to $([Num2Word]::NumberToText(1))" }
    if (($minutenum -ge 33) -and ($minutenum -lt 38) -and ($hournum -eq 12)) { $timetext = "five and twenty to $([Num2Word]::NumberToText(1))" }
    if (($minutenum -ge 28) -and ($minutenum -lt 33)) { $timetext = "half past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 23) -and ($minutenum -lt 28)) { $timetext = "five and twenty past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 18) -and ($minutenum -lt 23)) { $timetext = "twenty past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 13) -and ($minutenum -lt 18)) { $timetext = "quarter past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 6) -and ($minutenum -lt 13)) { $timetext = "ten past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 3) -and ($minutenum -lt 6)) { $timetext = "five past $([Num2Word]::NumberToText($hournum))" }
    if (($minutenum -ge 0) -and ($minutenum -lt 3)) { $timetext = "$([Num2Word]::NumberToText($hournum))o'clock" }

    $timeText
}