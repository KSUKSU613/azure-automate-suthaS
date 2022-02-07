[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når paramater ikke er gitt brukes default verdi
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop'
$webrequest = Invoke-WebRequest -Uri $UrlKortstokk
$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]$kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)" + ","
    }
    return $streng.TrimEnd(',')
}

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"


function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $kort.value -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }

            # Andre opsjon er
            <# 'J' { 10 }
            'Q' { 10 }
            'K' { 10 }
            'A' { 11 }
            Default { $kort.value } #>
        }    
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"

$meg = $kortstokk[0..1]

# Fjern 2 kort fra kortstokken som er gitt til $meg
$kortstokk = $kortstokk[2..$kortstokk.Count]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "Meg: $(kortstokkTilStreng -kortstokk $meg)" 

Write-Output "Magnus: $(kortstokkTilStreng -kortstokk $magnus)" 

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)" 