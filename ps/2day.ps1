$Path = "C:\Users\mzaor\moje\AdventOfCode"
$IDs = Get-Content -Path $Path\2day.txt

function Get-CharAppearanceCount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$ID
    )
    
    process {
        $CharArray = $ID.Trim().ToCharArray()
        $AppearanceMap = @{}

        for ($i = 0; $i -lt $CharArray.Count; $i++) {
            $CurrentCharacter = $CharArray[$i]

            if (-not($AppearanceMap.ContainsKey($CurrentCharacter))) {
                $AppearanceMap.Add($CurrentCharacter, 1)
                for ($j = $i + 1; $j -lt $CharArray.Count; $j++) {
                    if ($CharArray[$i] -eq $CharArray[$j]) {
                        $AppearanceMap[$CharArray[$i]]++
                    }
                }
            }
        }
        [PSCustomObject]@{
            Two   = $AppearanceMap.ContainsValue(2)
            Three = $AppearanceMap.ContainsValue(3)
        } 
    }   
}

$IDs | Get-CharAppearanceCount | ForEach-Object -Begin {$ThreeSum = 0; $TwoSum = 0} -Process {
    if ($PSItem.Two) { $TwoSum++ }
    if ($PSItem.Three) { $ThreeSum++ }
}

$TwoSum * $ThreeSum



