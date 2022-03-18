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
        }    
    }
    return $poengKortstokk
}

 Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
function skrivUtResultat {
    [OutputType([String])]
    param (      
        [object[]]$kortstokk
    )

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$minsum = $(sumPoengKortstokk -kortstokk $meg)
$magnussum = $(sumPoengKortstokk -kortstokk $magnus)


# bruker 'blackjack' som et begrep - er 21
$blackjack = 21
$vinner = ""
if ($minsum -eq $blackjack) {
    $vinner = "Meg1"
    break
}
elseif ($magnussum -eq $blackjack) {
    $vinner = "Magnus1"
    break
}
elseif ($minsum -eq $blackjack -and $magnussum -eq $blackjack) {
    $vinner = "Draw1"
    break
}
if ($minsum -le 21) {
    while($minsum -lt 17){
            $meg += $kortstokk[0]
            $kortstokk = $kortstokk[1..$kortstokk.Count]
            $minsum = sumPoengKortstokk -kortstokk $meg
                if ($minsum -gt 21) {
                    $vinner = "Magnus2"
                    break
                }
                elseif ($minsum -eq 21) {
                    $vinner = "Meg2" 
                    Write-Output "I am winner : $vinner"
                    break
                }
                $vinner = ""
            }
}
        
  if ($minsum -ge 17 -and $vinner -eq "") {
        while($magnussum -le $minsum) {
                $magnus += $kortstokk[0]
                $kortstokk = $kortstokk[1..$kortstokk.Count]
                $magnussum = sumPoengKortstokk -kortstokk $magnus
                    if ($magnussum -eq 21) {
                        $vinner = "Magnus3"
                        break
                    }
                    elseif ($magnussum -gt 21) {
                        $vinner = "Meg3"
                        break              
                    }
                  $vinner = ""  
                }
       
    }
 
    if ($minsum -ge 17 -and $minsum -le 20 -and $magnussum -ge 17 -and $magnussum -le 20) {
        if ($minsum -gt $magnsusum) {
            $vinner = "meg"
            break
        }
        elseif ($minsum -lt $magnussum){
            $vinner = "magnus"
            break
        }
        else {
            $vinner = "draw"
            break
        }
    }    

Write-Host "Vinner : $vinner"
Write-Host "Magnus : $magnussum  | $(kortstokkTilStreng -kortstokk $magnus)"
Write-Host "Meg : $minsum | $(kortstokkTilStreng -kortstokk $meg)" 
}

skrivUtResultat -kortstokk $kortstokk