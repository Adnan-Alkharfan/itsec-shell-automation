# Paths
$Output = "../data/windows_services.csv"
$LogFile = "../data/anomalies.log"

# Logging function
function Write-Log {
    param(
        [string]$Message
    )
    "$((Get-Date)) - $Message" | Out-File -Append -FilePath $LogFile
}

# Collect Windows services
$services = Get-Service | Select-Object Name, Status

# Export to CSV
$services | Export-Csv -NoTypeInformation -Path $Output

# Risky services list
$risky = @("Telnet", "RemoteRegistry", "Spooler")

# Check for risky services
foreach ($svc in $services) {
    if ($risky -contains $svc.Name) {
        Write-Log "VARNING – Riskabel Windows-tjänst upptäckt: $($svc.Name)"
    }
}

# Final log entry
Write-Log "Windows-kontroll klar."
