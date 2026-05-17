# ---------------------------------------------------------
# Filnamn: windows_check.ps1
# Syfte:   Träning – processer + tjänster + nätverk + riskkontroll
# Output:  windows_processes.csv + windows_output.json + anomalies.log
# ---------------------------------------------------------

$csvPath = "../data/windows_processes.csv"
$jsonPath = "../data/windows_output.json"
$logPath  = "../data/anomalies.log"

Write-Host "Samlar Windows-data..."
Start-Sleep -Milliseconds 500

# Steg 1: Processer
$processes = Get-Process | Select-Object Name, Id, CPU, WorkingSet
$processes | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Steg 2: Tjänster
$services = Get-Service

# Steg 3: Nätverksanslutningar
$connections = Get-NetTCPConnection | Select-Object LocalPort, RemoteAddress, State

# Steg 4: JSON
$json = @{
    timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    process_count = $processes.Count
    service_count = $services.Count
    network_connections = $connections.Count
    processes = $processes.Name
}

$json | ConvertTo-Json -Depth 4 | Out-File $jsonPath -Encoding UTF8

# Steg 5: Riskkontroll
"---- Windows Anomaly Log ----" | Out-File $logPath

# Process-baserade risker
foreach ($p in $processes) {
    switch -Wildcard ($p.Name) {
        "nc*"     { "Risk: Netcat-liknande process ($($p.Name))" | Out-File $logPath -Append }
        "curl*"   { "Risk: curl-liknande process ($($p.Name))" | Out-File $logPath -Append }
        "wget*"   { "Risk: wget-liknande process ($($p.Name))" | Out-File $logPath -Append }
        "ssh*"    { "Notice: SSH-relaterad process ($($p.Name))" | Out-File $logPath -Append }
        "python*" { "Info: Python-process körs ($($p.Name))" | Out-File $logPath -Append }
    }
}

# Tjänst-baserade risker
$dangerous = @("RemoteRegistry","TermService","WinRM","TlntSvr","Spooler")

foreach ($svc in $services) {
    if ($dangerous -contains $svc.Name -and $svc.Status -eq "Running") {
        "Risk: Dangerous service running ($($svc.Name))" | Out-File $logPath -Append
    }
}

# Nätverksrisker
foreach ($c in $connections) {
    if ($c.RemoteAddress -notin @("::1","127.0.0.1","0.0.0.0")) {
        "Notice: External connection ($($c.RemoteAddress):$($c.LocalPort))" | Out-File $logPath -Append
    }
}

Write-Host "Klar! Data sparad i data-mappen."
