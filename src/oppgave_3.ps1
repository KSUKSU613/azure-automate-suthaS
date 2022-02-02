$Url = "http://nav-deckofcards.herokuapp.com/shuffle"

$response = Invoke-WebRequest -Uri $Url



$cards = $response.content | ConvertFrom-Json

$kortstokk = @()
foreach ($card in $cards) {
   # $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
    $kortstokk += ($card.suit[0] + $card.value)

}

Write-Host "Kortstokk: $kortstokk"