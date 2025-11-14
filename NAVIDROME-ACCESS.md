# Accessing Navidrome at http://navidrome.tailnet

## Current Setup
- ✅ Navidrome is deployed and running
- ✅ Ingress is configured for `navidrome.tailnet`
- ✅ Traefik is handling routing
- ✅ Tailscale is running as a DaemonSet

## Steps to Access Navidrome

### 1. Verify Navidrome is Running
```bash
kubectl get pods -n navidrome
kubectl get ingress -n navidrome
kubectl get svc -n navidrome
```

### 2. Configure Tailscale Hostname

You need to set the hostname in Tailscale. On your Kubernetes node, run:

```bash
# Check if Tailscale is running
kubectl get pods -n tailscale

# Get the Tailscale IP of your node
kubectl exec -n tailscale -it <tailscale-pod-name> -- tailscale status

# Set the hostname (you'll need to do this via Tailscale admin console or CLI)
# The hostname should be: navidrome
```

**Via Tailscale Admin Console:**
1. Go to https://login.tailscale.com/admin/machines
2. Find your Kubernetes node
3. Click on it and set the hostname to `navidrome` (or add `navidrome` as an alias)

**Via Tailscale CLI (on the node):**
```bash
# SSH into your Kubernetes node
tailscale set --hostname=navidrome
```

### 3. Configure Tailscale DNS

For `navidrome.tailnet` to resolve, you need to:

**Option A: Use Tailscale MagicDNS (Recommended)**
1. Go to https://login.tailscale.com/admin/dns
2. Enable "MagicDNS"
3. Add a DNS record:
   - Name: `navidrome`
   - Points to: Your Kubernetes node's Tailscale IP

**Option B: Use Tailscale Funnel (for external access)**
If you want to access from outside your Tailnet:
1. Enable Tailscale Funnel on your node
2. Use the Funnel URL provided

### 4. Verify Access

**From a device on the same Tailnet:**
```bash
# Test DNS resolution
nslookup navidrome.tailnet

# Test HTTP access
curl http://navidrome.tailnet
```

**From a browser:**
- Open `http://navidrome.tailnet` in any browser on a device connected to your Tailnet

### 5. Troubleshooting

**If DNS doesn't resolve:**
- Check MagicDNS is enabled in Tailscale admin console
- Verify the hostname is set correctly
- Check Tailscale status: `kubectl exec -n tailscale <pod> -- tailscale status`

**If you get 404 or connection refused:**
- Check Traefik logs: `kubectl logs -n kube-system deployment/traefik`
- Verify ingress: `kubectl describe ingress -n navidrome navidrome`
- Check navidrome pod: `kubectl logs -n navidrome deployment/navidrome`

**If you can't access from other devices:**
- Ensure devices are on the same Tailnet
- Check Tailscale connection: `tailscale status` on the device
- Verify firewall rules allow traffic

### 6. Getting the Tailscale IP

To find your node's Tailscale IP:
```bash
kubectl exec -n tailscale <tailscale-pod-name> -- tailscale ip
```

Or check the Tailscale admin console for your node's IP address.

## Quick Health Check

Run these commands to verify everything is working:

```bash
# Check all components
kubectl get pods -n navidrome
kubectl get ingress -n navidrome
kubectl get svc -n navidrome
kubectl get pods -n tailscale

# Check Traefik is routing correctly
kubectl logs -n kube-system deployment/traefik --tail=20

# Test from inside the cluster
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- curl http://navidrome.navidrome.svc.cluster.local
```

