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

$Records = Get-Content -Path .\inputs\4day.txt
$SortedRecords = Invoke-ParseRecords -Records $Records | Sort-Object -Property Date
$Guards = @{}

# Gather data about guards:
# minutes grid and total
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

            if ($SortedRecords[$j].Action.StartsWith("Guard")) {
                $i = ($j - 1)
                break
            }
        }
    }
}

# determine guard with the largest 'total' value
$Maximum = 0
foreach ($Guard in $Guards.GetEnumerator()) {
    if ($Guard.Value['total'] -gt $Maximum) {
        $Maximum = $Guard.Value['total']
        $ID = $Guard.Name
    }
}

# determine minute with highest frequency of guard being asleep
$MostAsleepMinute = 0 # index of the largest value in the minutes array
$Max = 0
for ($i = 0; $i -lt 60; $i++) {
    if ($Guards[$ID]['minutes'][$i] -gt $Max) {
        $Max = $Guards[$ID]['minutes'][$i]
        $MostAsleepMinute = $i
    }
}


Write-Output "PART 1: Guard with largest total is Guard #$ID with total of $Maximum minutes asleep and most `"asleep`" minute being $MostAsleepMinute"
Write-Output "$ID times $MostAsleepMinute equals $([int]$ID * $MostAsleepMinute)"

# Part 2 - find the guard with largest frequency being asleep on particular minute
$MostFrequentMinute = 0
foreach ($Guard in $Guards.GetEnumerator()) {
    if ($Guard.Value['total'] -gt 0) {
        $MinutesGrid = $Guard.Value['minutes']
        # Count most asleep minute
        for ($i = 0; $i -lt 60; $i++) {
            if ($MinutesGrid[$i] -gt $MostFrequentMinute) {
                $MostFrequentMinute = $MinutesGrid[$i]
                $Minute = $i
                $ID = $Guard.Key
            }
        }
    }
} 

Write-Output "PART 2: Guard with largest single frequency of particular minute asleep is Guard #$ID and most `"asleep`" minute is $Minute"
Write-Output "$ID times $Minute equals $([int]$ID * $Minute)"






