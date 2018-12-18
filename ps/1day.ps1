[int[]]$Frequencies = Get-Content -Path "$HOME\Desktop\freq"
$Set = New-Object System.Collections.Generic.HashSet[int]

while (!$FrequencyFound) {
    :frequencyloop foreach ($Number in $Frequencies) {
        $CurrentSum += $Number

        if (-not ($Set.Add($CurrentSum))) {
            $FrequencyFound = $true
            $Part2 = $CurrentSum
            break frequencyloop
        }
    }
}

Write-Host $Part2