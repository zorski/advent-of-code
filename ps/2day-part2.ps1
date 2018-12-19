function Compare-Strings {
    [CmdletBinding()]
    param (
        [string]$StringOne,
        [string]$StringTwo
    )

    process {
        $Indexes = [System.Collections.ArrayList]::new()

        for ($i = 0; $i -lt $StringOne.Length; $i++) {
            if (-not($StringOne[$i] -eq $StringTwo[$i])) {
                if (-not($Indexes.Count -ge 1)) {
                    $Indexes.Add($i) | Out-Null
                } else {
                    $Indexes.Add($i) | Out-Null
                    break
                }
            }
        }

        if ($Indexes.Count -eq 1) {
            $StringOne.Remove($Indexes[0], 1)
        }
    }
}

$IDs = Get-Content -Path .\2day.txt

for ($i = 0; $i -lt $IDs.Count; $i++) {
    for ($j = $i+1; $j -lt $IDs.Count; $j++) {
        Compare-Strings -StringOne $IDs[$i] -StringTwo $IDs[$j]
    }
}

