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

$Material = New-Object 'int[,]' -ArgumentList 1000, 1000
$AllClaims = [HashSet[int]]@(1..1373)
$OverlappingClaimsSet = [HashSet[int]]::new()
$Claims = Get-Content -Path "$PSScriptRoot\3day.txt"

$Claims | Invoke-ElfClaimParsing | Convert-ElfClaimToCoordinates | ForEach-Object {
    $Claim = $PSItem.ClaimID

    while ($PSItem.Coordinates.Count -gt 0) {
        $Coordinate = $PSItem.Coordinates.Pop()
        $X = $Coordinate.X - 1 
        $Y = $Coordinate.Y - 1
        
        if ($Material[$X, $Y]) {
            # Add previous / existing claim
            [void]$OverlappingClaimsSet.Add(($Material[$X, $Y]))
            # Add current claim
            [void]$OverlappingClaimsSet.Add($Claim)
        } else {
            $Material[$X, $Y] = $Claim
        }
    }
}
$AllClaims.ExceptWith($OverlappingClaimsSet)
Write-Output $AllClaims
