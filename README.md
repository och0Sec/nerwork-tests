## Overview  
PowerShell script to run RFC 2544–style Layer 3 tests (TCP throughput, UDP loss/jitter, burst, recovery) against an iperf3 server and save logs locally.

## Prerequisites  
- **Windows 10+** with PowerShell  
- **iperf3.exe** (Windows build) in your `%PATH%` or script folder  
- **Network access** to an iperf3 server (private or public)

## iperf3 Binaries  
Download Windows builds from:  
https://github.com/ar51an/iperf3-win-builds/releases  
1. Grab the latest `iperf3.exe`.  
2. Unblock/Unzip and place alongside `Run-IperfTests.ps1` or add to `%PATH%`.

## Server Options  

### 1. Private iperf3 Server (recommended for consistent results)  
1. **Deploy a VM** (AWS, Azure, GCP, on-prem).  
2. **Install iperf3** (`sudo apt install iperf3` or Windows binary).  
3. **Open port 5201** (TCP/UDP) in firewall/security group.  
4. **Connect over VPN** if server isn’t public.  
5. Use private IP or hostname with `-Server`.

### 2. Public iperf3 Servers (quick setup)  
Refer to maintained list:  
https://github.com/R0GGER/public-iperf3-servers  
1. Pick a server IP/hostname.  
2. Note that availability, location, and throughput may vary.  
3. Pass chosen endpoint to `-Server`.

## Usage  

```powershell
.\Run-IperfTests.ps1 `
  -Server        <IP_or_Hostname> `
  [-OutputDir    <.\iperf_results>] `
  [-UDPBandwidth <100M>] `
  [-TestDuration <60>]
````

* **-Server**: iperf3 server address
* **-OutputDir**: folder for logs (default `.\iperf_results`)
* **-UDPBandwidth**: rate for UDP tests (default `100M`)
* **-TestDuration**: seconds per TCP/UDP test (default `60`)

## Examples

* **Private server over VPN**

  ```powershell
  .\Run-IperfTests.ps1 -Server 10.0.0.5
  ```

* **Public server**

  ```powershell
  .\Run-IperfTests.ps1 -Server 185.247.10.10
  ```

## Logs & Results

After completion, logs are saved as:

```
iperf_results\TCP_64.log  
iperf_results\UDP_512.log  
iperf_results\Burst_1s.log  
...
```

## Support

* Script issues: open an issue on this repo
* Questions: contact your network team or [author@example.com](mailto:author@example.com)
