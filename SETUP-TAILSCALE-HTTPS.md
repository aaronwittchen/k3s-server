# Setting Up HTTPS with Tailscale Certificates

## The Problem
- Let's Encrypt can't issue certificates for `.ts.net` domains
- Tailscale provides certificates, but they're on the client, not in Kubernetes
- We need to extract Tailscale's certificates and import them into Kubernetes

## Solution: Use Tailscale's Certificates

Tailscale automatically provisions certificates for `.ts.net` domains when HTTPS is enabled. We need to extract these and use them in Kubernetes.

### Step 1: Enable HTTPS Certificates in Tailscale

1. Go to https://login.tailscale.com/admin/dns
2. Enable "HTTPS Certificates"
3. Save

### Step 2: Get Tailscale Certificate (On Windows Host)

Tailscale stores certificates in:
- Windows: `%LOCALAPPDATA%\Tailscale\certs\`
- Or use: `tailscale cert --help` to see certificate commands

```powershell
# Check if certificates are available
tailscale cert navidrome.tail4b8401.ts.net

# This will output the certificate and key
# Save them to files:
tailscale cert navidrome.tail4b8401.ts.net > navidrome.crt
tailscale cert --key navidrome.tail4b8401.ts.net > navidrome.key
```

### Step 3: Create Kubernetes Secret

```powershell
# Create the TLS secret in Kubernetes
kubectl create secret tls navidrome-tls \
  --cert=navidrome.crt \
  --key=navidrome.key \
  -n navidrome
```

### Step 4: Re-enable TLS in Ingress

Update the ingress to use the secret:

```yaml
spec:
  ingressClassName: traefik
  tls:
    - hosts:
        - navidrome.tailnet
        - navidrome.tail4b8401.ts.net
      secretName: navidrome-tls
```

## Alternative: Use HTTP Only (Simpler)

Since Tailscale already encrypts all traffic at the VPN level, HTTP is actually secure for internal use. The traffic is encrypted by Tailscale's WireGuard protocol.

**Pros of HTTP:**
- ✅ Simpler setup
- ✅ Already encrypted by Tailscale
- ✅ No certificate management
- ✅ Works immediately

**Cons:**
- ❌ Browser shows "Not Secure" (even though it is)
- ❌ Some apps may require HTTPS

## Recommendation

For a private Tailscale network, **HTTP is fine** since Tailscale encrypts everything. However, if you want the green lock in the browser, follow the steps above to use Tailscale's certificates.

