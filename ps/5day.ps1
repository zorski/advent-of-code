$Polymer = Get-Content -Path .\inputs\5day.txt
# $Polymer = ""
# $Polymer = "dabAcCaCBAcCcaDA"
function Test-Letter {
    # Function tests if letters are the same but different case:
    # a ? A -> true
    # a ? b -> false
    # BUT
    # a ? a -> false
    param (
        [char]$FirstChar,
        [char]$SecondChar
    )

    [System.Math]::Abs([byte]$FirstChar - [byte]$SecondChar) -eq 32  
}
function React-Polymer {
    [cmdletbinding()]
    param (
        [string]$Polymer  
    )
    
    for ($i = (0 + [math]::Max(0,($i-1))); $i -lt ($Polymer.Length - 1); $i++) {
        if (Test-Letter -FirstChar $Polymer[$i] -SecondChar $Polymer[$i + 1]) {
            # remove from string these two letters
            $Polymer = React-Polymer -Polymer $Polymer.Remove($i, 2)
        }
    }
    return $Polymer
}

React-Polymer -Polymer $Polymer