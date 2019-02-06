$Polymer = Get-Content -Path .\inputs\5day.txt
$Polymer = "dabAcCaCBAcCcaDA"
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
    [CmdletBinding()]
    param (
        [string]$Polymer  
    )

    $Buffer = [System.Collections.Generic.Stack[System.Char]]::new('.')

    foreach ($Character in $Polymer.ToCharArray()) {
        if (Test-Letter -FirstChar $Buffer.Peek() -SecondChar $Character) {
            [void]$Buffer.Pop()
        } else {
            $Buffer.Push($Character)
        }
    } 
    $Buffer 
}

$Result = React-Polymer -Polymer $Polymer

