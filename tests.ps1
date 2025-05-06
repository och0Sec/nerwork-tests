<#
.SYNOPSIS
  Run RFC-2544 style Layer 3 tests against an iperf3 server and save logs.

.PARAMETER Server
  IP or hostname of the iperf3 server.

.PARAMETER OutputDir
  Folder to store log files (default .\iperf_results).

.PARAMETER UDPBandwidth
  UDP send rate for loss/jitter tests (default 100M).

.PARAMETER TestDuration
  Duration of each TCP/UDP test in seconds (default 60).

.EXAMPLE
  .\Run-IperfTests.ps1 -Server 203.0.113.5
#>
param(
  [Parameter(Mandatory)][string]$Server,
  [string]$OutputDir   = ".\iperf_results",
  [string]$UDPBandwidth = "100M",
  [int]   $TestDuration = 60
)

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
  New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Define packet sizes to sweep
$packetSizes = 64,128,256,512,1024,1518

# TCP throughput tests
foreach ($size in $packetSizes) {
  $outfile = Join-Path $OutputDir "TCP_${size}.log"
  Write-Host "[$(Get-Date -Format T)] TCP test @ $size B → $outfile"
  & iperf3.exe -c $Server -l $size -t $TestDuration `
    | Tee-Object -FilePath $outfile
}

# UDP loss/jitter tests
foreach ($size in $packetSizes) {
  $outfile = Join-Path $OutputDir "UDP_${size}.log"
  Write-Host "[$(Get-Date -Format T)] UDP test @ $size B, $UDPBandwidth → $outfile"
  & iperf3.exe -c $Server -u -b $UDPBandwidth -l $size -t $TestDuration `
    | Tee-Object -FilePath $outfile
}

# Burst-handling test (1 s at line rate)
$burstFile = Join-Path $OutputDir "Burst_1s.log"
Write-Host "[$(Get-Date -Format T)] Burst test (1 s @ $UDPBandwidth) → $burstFile"
& iperf3.exe -c $Server -u -b $UDPBandwidth -l 64 -t 1 --burst `
  | Tee-Object -FilePath $burstFile

Write-Host "All tests complete. Results in: $OutputDir"
