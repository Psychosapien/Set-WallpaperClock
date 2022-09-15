function Get-DateOrdinalSuffix([datetime]$Date) {
    switch -regex ($Date.Day.ToString()) {
        '1(1|2|3)$' { 'th'; break }
        '.?1$'      { 'st'; break }
        '.?2$'      { 'nd'; break }
        '.?3$'      { 'rd'; break }
        default     { 'th'; break }
    }
}