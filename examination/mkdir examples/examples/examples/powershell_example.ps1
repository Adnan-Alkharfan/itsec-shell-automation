# ---------------------------------------------------------
# Exempel: Kontroll av Windows-tjänster i PowerShell
# Syfte:   Visa hur PowerShell arbetar med objekt
# ---------------------------------------------------------

# Hämtar alla tjänster som är stoppade
$services = Get-Service | Where-Object { $_.Status -eq "Stopped" }

# Skriver ut namn och status
$services | Select-Object Name, Status
