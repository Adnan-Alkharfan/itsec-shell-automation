# Init counters
$failed = 0
$errorCount = 0
$unauth = 0

# Function to write logs
function Write-Log {
    param([string]$Message)
    Add-Content -Path "analysis.log" -Value $Message
}

# Read log file
Get-Content "sample.log" | ForEach-Object {
    $line = $_

    if ($line -match "failed") {
        Write-Log "Misslyckat inloggningsförsök: $line"
        $failed++
    }

    if ($line -match "error") {
        Write-Log "Error hittad: $line"
        $errorCount++
    }

    if ($line -match "unauthorized") {
        Write-Log "Obehörigt försök: $line"
        $unauth++
    }
}

# Slutrapport
Write-Log "ANALYS KLAR"
Write-Log "Antal misslyckade inloggningar: $failed"
Write-Log "Antal errors: $errorCount"
Write-Log "Antal obehöriga försök: $unauth"