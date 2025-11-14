# Setting Up Symfonium with Navidrome (Subsonic API)

## Overview
Navidrome has built-in Subsonic API support, so Symfonium can connect and stream your music.

## Prerequisites
1. ✅ Navidrome is running and accessible
2. ✅ You have a Navidrome user account (create one in the web UI)
3. ✅ Your phone has Tailscale installed and connected to the same tailnet

## Step 1: Install Tailscale on Your Phone

**Android:**
- Install from Google Play Store
- Sign in with your Tailscale account
- Connect to your tailnet

**iOS:**
- Install from App Store
- Sign in with your Tailscale account
- Connect to your tailnet

## Step 2: Verify Access from Phone

1. Open a browser on your phone
2. Go to: `http://navidrome.tail4b8401.ts.net`
3. You should see the Navidrome web interface
4. If it doesn't work, check:
   - Tailscale is connected on your phone
   - MagicDNS is enabled in Tailscale admin console
   - DNS is configured (should be automatic on mobile)

## Step 3: Configure Symfonium

### Important: Base Path Configuration

Your Navidrome is configured with `ND_BASEPATH=/navidrome`, so the Subsonic API endpoint is at:
- **Base URL**: `http://navidrome.tail4b8401.ts.net/navidrome`
- **NOT**: `http://navidrome.tail4b8401.ts.net` (this won't work for Subsonic API)

### Symfonium Settings:

1. **Open Symfonium app**
2. **Add Server** or **Settings → Servers**
3. **Server Type**: Select "Subsonic" or "Navidrome"
4. **Server URL**: `http://navidrome.tail4b8401.ts.net/navidrome`
   - ⚠️ **Important**: Include `/navidrome` at the end
5. **Username**: Your Navidrome username
6. **Password**: Your Navidrome password
7. **API Version**: Leave as default (usually 1.16.0 or auto-detect)
8. **Test Connection**: Tap to verify it works

### Alternative URL Format:

If the above doesn't work, try:
- **Server URL**: `http://navidrome.tail4b8401.ts.net`
- **Base Path**: `/navidrome` (if Symfonium has a separate base path field)

## Step 4: Verify Subsonic API Endpoint

You can test the Subsonic API directly:

```bash
# Test from your phone's browser or computer:
http://navidrome.tail4b8401.ts.net/navidrome/rest/ping.view?u=USERNAME&p=PASSWORD&v=1.16.0&c=symfonium
```

Replace:
- `USERNAME` with your Navidrome username
- `PASSWORD` with your Navidrome password

If this returns XML, the API is working!

## Troubleshooting

### "Connection Failed" or "Cannot Connect"

1. **Check Tailscale on phone:**
   - Open Tailscale app
   - Verify you're connected (green status)
   - Check your phone's Tailscale IP

2. **Test DNS resolution:**
   - On phone, try opening `http://navidrome.tail4b8401.ts.net` in browser
   - If it doesn't load, DNS isn't working

3. **Check base path:**
   - Make sure you're using `/navidrome` in the URL
   - The Subsonic API is at `/navidrome/rest/`, not `/rest/`

4. **Check credentials:**
   - Verify username/password in Navidrome web UI
   - Try logging into the web UI first

### "Invalid Credentials"

1. Create a user in Navidrome web UI:
   - Go to `http://navidrome.tail4b8401.ts.net`
   - Settings → Users → Create User
   - Use this username/password in Symfonium

### "Server Not Found"

1. Verify the URL format:
   - ✅ Correct: `http://navidrome.tail4b8401.ts.net/navidrome`
   - ❌ Wrong: `http://navidrome.tail4b8401.ts.net`
   - ❌ Wrong: `https://navidrome.tail4b8401.ts.net` (unless you set up HTTPS)

## Quick Reference

- **Navidrome Web UI**: `http://navidrome.tail4b8401.ts.net`
- **Subsonic API Base**: `http://navidrome.tail4b8401.ts.net/navidrome`
- **Subsonic API Endpoint**: `http://navidrome.tail4b8401.ts.net/navidrome/rest/`

## Note About Music Storage

Currently, your Navidrome deployment uses `emptyDir` for the music folder, which means:
- Music is stored in the pod (temporary)
- Music will be lost if the pod restarts

To store music permanently, you'll need to:
1. Mount a persistent volume
2. Or use a hostPath volume pointing to your laptop's music folder

Would you like help setting up persistent storage for your music?

