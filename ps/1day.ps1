[int[]]$Frequencies = Get-Content -Path "$PSScriptRoot\..\python\1day-input.txt"
$Set = New-Object System.Collections.Generic.HashSet[int]
$iteration = 0

while (!$FrequencyFound) {
    Write-Output $iteration++
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