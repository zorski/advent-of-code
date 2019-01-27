function Invoke-ParseRecords {
    [CmdletBinding()]
    param (
        $Records
    )

    $ParsedRecords = [System.Collections.ArrayList]::new()

    foreach ($Record in $Records) {
        if ($Record -match "^\[(?<date>[\d-:\s]+)\]\s(?<action>.*)") {
            [void]$ParsedRecords.Add(
                [PSCustomObject]@{
                    Date   = ([datetime]$Matches['date'])
                    Action = $Matches['action']
                }
            )
        } else {
            Write-Warning -Message "Record: $Record - not parsed"
        }
    }

    $ParsedRecords
}

# $Records = Get-Content -Path .\inputs\4day.txt
$Records = @"
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:05] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:36] falls asleep
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
[1518-11-01 00:00] Guard #10 begins shift
"@ -split "`n", "" | ForEach-Object { $PSItem.Trim() }


$SortedRecords = Invoke-ParseRecords -Records $Records | Sort-Object -Property Date
$Guards = @{}

for ($i = 0; $i -lt $SortedRecords.Count; $i++) {

    if ($SortedRecords[$i].Action -match "^Guard\s#(?<id>\d+)\sbegins\sshift$") {
        $GuardID = $Matches['id']
        if (-not($Guards.ContainsKey($GuardID))) {
            $Guards.Add($GuardID, @{minutes = [int[]]::new(60);total = 0})
        }

        for ($j = $i+1; $j -lt $SortedRecords.Count; $j++) {
            if ($SortedRecords[$j].Action -eq "falls asleep") {
                $MinuteAsleep = $SortedRecords[$j].Date.Minute
            }

            if ($SortedRecords[$j].Action -eq "wakes up") {
                $MinuteWakesUp = $SortedRecords[$j].Date.Minute
                # Add Total and Populate the 'minutes' grid
                $Guards[$GuardID]['total'] += ($MinuteWakesUp - $MinuteAsleep)
                $MinuteAsleep..($MinuteWakesUp - 1) | ForEach-Object { $Guards[$GuardID]['minutes'][$PSItem]++ }
            }

            if ($SortedRecords[$j].Action.StartsWith("Guard")){
                break
            }
        }
    }
}











