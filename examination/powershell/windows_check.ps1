# ---------------------------------------------------------
# Filnamn: windows_check.ps1
# Syfte:   Samla Windows-tjänster, identifiera risker och
#          generera CSV + anomalier för Python-analysen.
# Output:  windows_output.csv, anomalies.log
# Författare: Adnan
# Datum: 2026-04-14
# ---------------------------------------------------------

$csvPath = "../data/windows_output.csv"
$anomalyPath = "../data/anomalies.log"

# ---------------------------------------------------------
# Moment 1 – Samla tjänster
# ---------------------------------------------------------
function Get-ServicesData {
    Get-Service | Select-Object Name, Status |
        Export-Csv -Path $csvPath -NoTypeInformation
}

# ---------------------------------------------------------
# Moment 3 – Kontrollera kritiska tjänster
# ---------------------------------------------------------
function Test-ConfigStatus {
    $critical = @("WinDefend", "EventLog")

    foreach ($svc in $critical) {
        $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($service.Status -ne "Running") {
            Add-Content -Path $anomalyPath -Value "Kritisk tjänst ej aktiv: $svc"
        }
    }
}

# ---------------------------------------------------------
# Moment 3 – Identifiera riskabla tjänster
# ---------------------------------------------------------
function Test-RiskyServices {
    $risky = @("RemoteRegistry", "Telnet", "SNMP")

    foreach ($svc in $risky) {
        $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($service -and $service.Status -eq "Running") {
            Add-Content -Path $anomalyPath -Value "Riskabel tjänst aktiv: $svc"
        }
    }
}

# ---------------------------------------------------------
# Huvudflöde – Moment 4 komplett
# ---------------------------------------------------------
Test-ConfigStatus
Get-ServicesData
Test-RiskyServices
