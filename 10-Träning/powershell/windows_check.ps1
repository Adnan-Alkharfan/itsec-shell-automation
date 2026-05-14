# ---------------------------------------------------------
# Filnamn: windows_check.ps1
# Syfte:   Träning – samla processer i Windows
# Output:  windows_processes.csv + windows_output.json
# ---------------------------------------------------------

$csvPath = "../data/windows_processes.csv"
$jsonPath = "../data/windows_output.json"
$logPath  = "../data/anomalies.log"

Write-Host "Samlar Windows-processer..."
Start-Sleep -Milliseconds 500

# Steg 1: Hämta processer
$processes = Get-Process | Select-Object Name, Id, CPU, WorkingSet

# Steg 2: Exportera CSV
$processes | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Steg 3: Skriv JSON
$json = @{
    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    process_count = $processes.Count
    processes = $processes.Name
}

$json | ConvertTo-Json -Depth 3 | Out-File $jsonPath -Encoding UTF8

# Steg 4: Enkel riskkontroll
"---- Windows Anomaly Log ----" | Out-File $logPath

foreach ($p in $processes) {
    switch -Wildcard ($p.Name) {
        "nc*"     { "Risk: Netcat-liknande process upptäckt ($($p.Name))" | Out-File $logPath -Append }
        "curl*"   { "Risk: curl-liknande process upptäckt ($($p.Name))" | Out-File $logPath -Append }
        "wget*"   { "Risk: wget-liknande process upptäckt ($($p.Name))" | Out-File $logPath -Append }
        "ssh*"    { "Notice: SSH-relaterad process ($($p.Name))" | Out-File $logPath -Append }
        "python*" { "Info: Python-process körs ($($p.Name))" | Out-File $logPath -Append }
    }
}

Write-Host "Klar! Data sparad i data-mappen."
