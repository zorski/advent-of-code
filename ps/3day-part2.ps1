#Require -Version 5.0
using namespace System.Management.Automation.Host
using namespace System.Collections.Generic

function Invoke-ElfClaimParsing {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Claim
    )

    process {
        if ($Claim -match "^#(?<id>\d+)\s@\s(?<left>\d+),(?<top>\d+):\s(?<width>\d+)x(?<height>\d+)$") {
            [PSCustomObject]@{
                Id     = [int]$Matches['id']
                Left   = [int]$Matches['left']
                Top    = [int]$Matches['top']
                Width  = [int]$Matches['width']
                Height = [int]$Matches['height']
            }
        } else {
            Write-Error "Claim: $Claim was not parsed properly by regex"
        }
    }
}

function Convert-ElfClaimToCoordinates {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSCustomObject]$Claim
    )
    process {
        [int]$left = $Claim.Left
        [int]$top = $Claim.Top
        [int]$width = $Claim.Width
        [int]$height = $Claim.Height
        $CoordinatesObject = [PSCustomObject]@{
            ClaimID     = $Claim.Id
            Coordinates = [System.Collections.Generic.Stack[Coordinates]]::new()
        }

        for ($x = $left + 1; $x -le $width + $left; $x++) {
            for ($y = $top + 1; $y -le $height + $top; $y++) {
                $CoordinatesObject.Coordinates.Push([Coordinates]::new($x, $y))
            }
        }

        $CoordinatesObject
    }
}

$Counter = 0
$Set = [HashSet[Coordinates]]::new()
$HelperSet = [HashSet[Coordinates]]::new()
$AllClaimsSet = [HashSet[int]]::new()
1..3 | ForEach-Object { [void]$AllClaimsSet.Add($PSItem) }
$OverlappingClaimsSet = [HashSet[int]]::new()

# $Claims = Get-Content -Path "C:\Users\michal.zaorski\Documents\moje\AdventOfCode\advent-of-code\3day.txt"
$Claims = @"
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
"@ -split "`n", "" | ForEach-Object { $PSItem.Trim() }

$Claims | Invoke-ElfClaimParsing | Convert-ElfClaimToCoordinates | ForEach-Object {

    while ($PSItem.Coordinates.Count -gt 0) {
        $Coordinate = $PSItem.Coordinates.Pop()

        if (-not($Set.Add($Coordinate))) {
            [void]$OverlappingClaimsSet.Add($PSItem.ClaimID)
            break
        }
    }
}

# Write-Output "How many square inches of fabric are within two or more claims? $Counter"
# Write-Output "Claim: {0}" -f $($ClaimsSet.ExceptWith($DuplicateClaimsSet))

