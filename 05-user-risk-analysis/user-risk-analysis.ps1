# PowerShell User Risk Analysis Script

$logfile = "user_risk_report.log"

function Log {
    param($message)
    $timestamp = Get-Date -Format "ddd, MMM d, yyyy h:mm:ss tt"
    "$timestamp - $message" | Tee-Object -FilePath $logfile -Append
}

# Read CSV
$users = Import-Csv -Path "users.csv"

foreach ($user in $users) {

    $username = $user.username
    $days     = [int]$user.last_login_days
    $status   = $user.status.Trim()

    if ($days -gt 180 -and $status -eq "disabled") {
        Log "$username – KRITISK RISK (inaktiv > 180 dagar & disabled)"
    }
    elseif ($days -gt 180) {
        Log "$username – HIGH RISK (inaktiv > 180 dagar)"
    }
    elseif ($days -gt 90) {
        Log "$username – MEDIUM RISK (inaktiv > 90 dagar)"
    }
    elseif ($status -eq "disabled") {
        Log "$username – WARNING (disabled men nyligen inloggad)"
    }
    else {
        Log "$username – OK"
    }
}

Log "Analys slutförd."
