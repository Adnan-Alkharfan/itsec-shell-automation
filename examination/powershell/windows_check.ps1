# ---------------------------------------------------------
# Filnamn: windows_check.ps1
# Syfte:   Grundstruktur för Windows-säkerhetskontroller.
#          Skriptet hämtar tjänster, loggar händelser och
#          förbereder data för vidare analys.
# Output:  CSV-data + loggar
# Författare: Adnan
# Datum: (Get-Date -Format "yyyy-MM-dd")
# ---------------------------------------------------------

# Loggfil
$LogFile = "../data/anomalies.log"

# Funktion: skriver loggar med tidsstämpel
function Write-Log {
    param([string]$Message)

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp INFO: $Message"
}

# Funktion: hämtar alla tjänster (grundläggande moment)
function Get-ServiceList {
    try {
        $services = Get-Service
        Write-Log "Hämtade tjänstelistan."
        return $services
    }
    catch {
        Write-Log "FEL: Kunde inte hämta tjänster. $_"
        return $null
    }
}

# Funktion: enkel riskkontroll (moment 1 nivå)
function Test-ServiceRisk {
    param([array]$Services)

    # Enkel risklista för moment 1
    $RiskList = @(
        "RemoteRegistry",
        "Telnet"
    )

    foreach ($service in $Services) {
        if ($RiskList -contains $service.Name) {
            Write-Log "Riskabel tjänst upptäckt: $($service.Name)"
        }
    }
}

# ---------------------------------------------------------
# Funktion: Enkel kontroll av systemkonfiguration
# Syfte:   Kontrollera om viktiga tjänster är stoppade
# ---------------------------------------------------------
function Test-ConfigStatus {
    $critical = "WinDefend", "EventLog"

    foreach ($service in $critical) {
        $s = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($s.Status -ne "Running") {
            Write-Log "VARNING: Kritisk tjänst ej igång: $service"
        }
    }
}

# ---------------------------------------------------------
# Huvudflöde
# ---------------------------------------------------------
$AllServices = Get-ServiceList

if ($AllServices) {

    # Exportera tjänster till CSV (krav i moment 1)
    $AllServices |
        Select-Object Name, Status, DisplayName |
        Export-Csv -Path "../data/windows_output.csv" -NoTypeInformation

    Write-Log "Exporterade tjänster till windows_output.csv."

    # Kör enkel konfigurationskontroll
    Test-ConfigStatus

    # Kör enkel riskkontroll
    Test-ServiceRisk -Services $AllServices
}
else {
    Write-Log "FEL: Inga tjänster kunde analyseras."
}
