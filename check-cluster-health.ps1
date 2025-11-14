# Kubernetes Cluster Health Check Script

Write-Host "=== Kubernetes Cluster Health Check ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Node Status:" -ForegroundColor Yellow
kubectl get nodes -o wide
Write-Host ""

Write-Host "2. All Pods Status (all namespaces):" -ForegroundColor Yellow
kubectl get pods -A
Write-Host ""

Write-Host "3. Pods with Issues:" -ForegroundColor Yellow
kubectl get pods -A --field-selector=status.phase!=Running
Write-Host ""

Write-Host "4. Services:" -ForegroundColor Yellow
kubectl get svc -A
Write-Host ""

Write-Host "5. Ingresses:" -ForegroundColor Yellow
kubectl get ingress -A
Write-Host ""

Write-Host "6. Deployments:" -ForegroundColor Yellow
kubectl get deployments -A
Write-Host ""

Write-Host "7. System Component Health:" -ForegroundColor Yellow
Write-Host "   CoreDNS:"
kubectl get pods -n kube-system -l k8s-app=kube-dns
Write-Host "   Traefik:"
kubectl get pods -n kube-system -l app.kubernetes.io/name=traefik
Write-Host ""

Write-Host "8. Recent Events (last 20):" -ForegroundColor Yellow
kubectl get events -A --sort-by='.lastTimestamp' | Select-Object -Last 20
Write-Host ""

Write-Host "9. Resource Usage (if metrics-server is available):" -ForegroundColor Yellow
kubectl top nodes 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "Metrics server not available" }
kubectl top pods -A 2>$null
if ($LASTEXITCODE -ne 0) { Write-Host "Metrics server not available" }
Write-Host ""

Write-Host "10. Flux Status:" -ForegroundColor Yellow
kubectl get kustomizations -n flux-system
kubectl get gitrepositories -n flux-system
Write-Host ""

Write-Host "=== Health Check Complete ===" -ForegroundColor Green

