# Test Navidrome Access Script

Write-Host "=== Testing Navidrome Access ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Testing DNS Resolution:" -ForegroundColor Yellow
$dnsResult = Resolve-DnsName -Name "navidrome.tailnet" -ErrorAction SilentlyContinue
if ($dnsResult) {
    Write-Host "   ✓ DNS resolves to: $($dnsResult[0].IPAddress)" -ForegroundColor Green
} else {
    Write-Host "   ✗ DNS does not resolve" -ForegroundColor Red
    Write-Host "   Make sure:" -ForegroundColor Yellow
    Write-Host "   - MagicDNS is enabled in Tailscale admin console" -ForegroundColor Yellow
    Write-Host "   - Your DNS is set to 100.100.100.100" -ForegroundColor Yellow
    Write-Host "   - The debian node has hostname 'navidrome' set" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "2. Testing HTTP Access:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://navidrome.tailnet" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    Write-Host "   ✓ HTTP access works! Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response length: $($response.Content.Length) bytes" -ForegroundColor Gray
} catch {
    Write-Host "   ✗ HTTP access failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Message -like "*resolve*") {
        Write-Host "   → DNS resolution issue. Check DNS settings." -ForegroundColor Yellow
    } elseif ($_.Exception.Message -like "*timeout*" -or $_.Exception.Message -like "*connect*") {
        Write-Host "   → Connection issue. Check:" -ForegroundColor Yellow
        Write-Host "     - Is navidrome pod running?" -ForegroundColor Yellow
        Write-Host "     - Is ingress configured correctly?" -ForegroundColor Yellow
        Write-Host "     - Is Traefik running?" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "3. Checking Tailscale Status:" -ForegroundColor Yellow
$tailscaleStatus = & tailscale status 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   Tailscale is connected" -ForegroundColor Green
    Write-Host $tailscaleStatus
} else {
    Write-Host "   ✗ Could not check Tailscale status (tailscale CLI not found)" -ForegroundColor Yellow
    Write-Host "   Make sure Tailscale client is installed and running" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "=== Test Complete ===" -ForegroundColor Cyan

