$logfile = "process_check.log"

function Log {
    param([string]$msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $msg" | Tee-Object -FilePath $logfile -Append
}

function Check-Process {
    param([string]$p)

    if (Get-Process -Name $p -ErrorAction SilentlyContinue) {
        Log "Processen '$p' körs."
    } else {
        Log "VARNING: Processen '$p' körs inte."
    }
}

function Run-Checks {
    param([string]$file)

    if (-not (Test-Path $file)) {
        Log "FEL: Filen $file saknas."
        exit
    }

    foreach ($process in Get-Content $file) {
        if ($process.Trim() -eq "") { continue }
        Check-Process $process.Trim()
    }
}

Run-Checks "Windows-processlist.txt"