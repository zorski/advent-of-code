$Records = Get-Content -Path .\inputs\4day.txt
$GuardsHashTable = @{}
function Sort-Records {
    [CmdletBinding()]
    param (
        $Records
    )

    $TimeIDs = [System.Collections.ArrayList]::new()

    foreach ($Line in $ShiftTimestamps) {
        $Line -match "^\[(?<date>[\d-:\s]+)\]\s(?<action>.*)" | Out-Null
        [void]$TimeIDs.Add(
            [PSCustomObject]@{
                Date   = $Matches['date']
                Action = $Matches['action']
            }
        )
    }

    $TimeIDs | Sort-Object { $PSItem.Date -as [datetime] }
}

$SortedRecords = Sort-Records -Records $Records

for ($i = 0; $i -lt $SortedRecords.Count; $i++) {
    if ($SortedRecords[$i].Action -match "^Guard\s(?<id>#\d+)\sbegins shift$") {
        $Id = $Matches['id']
        if (-not($GuardsHashTable.ContainsKey($Id))) {
            $GuardsHashTable.Add($Id, $null)
        }

        $j = $i+1
        while (-not($SortedRecords[$j].Action.StartsWith("Guard"))) {
            if ($SortedRecords[$j].Action -eq 'falls asleep') {
                $FallAsleepMinute = ($SortedRecords[$j].Date -split ":")[-1]
            }

            if ($SortedRecords[$j].Action -eq 'wakes up') {
                $WakeUpMinute = ($SortedRecords[$j].Date -split ":")[-1]
            }
        }
    }
}











