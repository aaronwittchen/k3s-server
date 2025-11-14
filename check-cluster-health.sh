#!/bin/bash

echo "=== Kubernetes Cluster Health Check ==="
echo ""

echo "1. Node Status:"
kubectl get nodes -o wide
echo ""

echo "2. All Pods Status (all namespaces):"
kubectl get pods -A
echo ""

echo "3. Pods with Issues:"
kubectl get pods -A --field-selector=status.phase!=Running
echo ""

echo "4. Services:"
kubectl get svc -A
echo ""

echo "5. Ingresses:"
kubectl get ingress -A
echo ""

echo "6. Deployments:"
kubectl get deployments -A
echo ""

echo "7. System Component Health:"
echo "   CoreDNS:"
kubectl get pods -n kube-system -l k8s-app=kube-dns
echo "   Traefik:"
kubectl get pods -n kube-system -l app.kubernetes.io/name=traefik
echo ""

echo "8. Recent Events (last 20):"
kubectl get events -A --sort-by='.lastTimestamp' | tail -20
echo ""

echo "9. Resource Usage (if metrics-server is available):"
kubectl top nodes 2>/dev/null || echo "Metrics server not available"
kubectl top pods -A 2>/dev/null || echo "Metrics server not available"
echo ""

echo "10. Flux Status:"
kubectl get kustomizations -n flux-system
kubectl get gitrepositories -n flux-system
echo ""

echo "=== Health Check Complete ==="

