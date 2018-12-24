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
        if ($Claim -match "^(?<id>#\d+)\s@\s(?<left>\d+),(?<top>\d+):\s(?<width>\d+)x(?<height>\d+)$") {
            [PSCustomObject]@{
                Id     = $Matches['id']
                Left   = $Matches['left']
                Top    = $Matches['top']
                Width  = $Matches['width']
                Height = $Matches['height']
            } 
        }
        else {
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

        for ($x = $left + 1; $x -le $width + $left; $x++) {
            for ($y = $top + 1; $y -le $height + $top; $y++) {
                [Coordinates]::new($x, $y)
            }
        }
    }  
}

$Counter = 0
$Set = [HashSet[Coordinates]]::new()
$HelperSet = [HashSet[Coordinates]]::new()

$Claims = Get-Content -Path $PSScriptRoot\3day.txt
$Claims  | Invoke-ElfClaimParsing | Convert-ElfClaimToCoordinates | ForEach-Object {
    if (-not($Set.Add($PSItem))) {
        if (-not($HelperSet.Contains($PSItem))) {
            [void]$HelperSet.Add($PSItem)
            $Counter++
        }
    }
}

Write-Output "How many square inches of fabric are within two or more claims? $Counter"

