# Setting Up VirtualBox Shared Folder for Navidrome Music

## Overview
Mount your Windows laptop's music folder into the Debian VM so Navidrome can access your FLAC files.

## Step 1: Install VirtualBox Guest Additions in Debian VM

1. **In your Debian VM, install required packages:**
   ```bash
   sudo apt update
   sudo apt install -y build-essential dkms linux-headers-$(uname -r)
   ```

2. **Mount the Guest Additions CD:**
   - In VirtualBox, go to: **Devices → Insert Guest Additions CD image**
   - Or manually: **Devices → Optical Drives → Choose disk image** → Select `VBoxGuestAdditions.iso` (usually in VirtualBox installation folder)

3. **Install Guest Additions:**
   ```bash
   # Mount the CD (if not auto-mounted)
   sudo mount /dev/cdrom /mnt
   
   # Run the installer
   sudo /mnt/VBoxLinuxAdditions.run
   
   # If it fails, try:
   sudo bash /mnt/VBoxLinuxAdditions.run
   
   # Reboot the VM
   sudo reboot
   ```

4. **Verify installation:**
   ```bash
   lsmod | grep vboxguest
   # Should show vboxguest module loaded
   ```

## Step 2: Create Shared Folder in VirtualBox

1. **Shut down the VM** (if running)

2. **In VirtualBox Manager:**
   - Right-click your VM → **Settings**
   - Go to **Shared Folders**
   - Click the **+** icon (Add Shared Folder)

3. **Configure the shared folder:**
   - **Folder Path**: Browse to your Windows music folder (e.g., `C:\Users\YourName\Music` or `D:\Music`)
   - **Folder Name**: `music` (or any name you prefer)
   - **Read-only**: Unchecked (so Navidrome can write metadata)
   - **Auto-mount**: ✅ Checked
   - **Mount Point**: `/media/sf_music` (default, or choose your own)
   - **Permanent**: ✅ Checked

4. **Click OK** and start the VM

## Step 3: Mount the Shared Folder in Debian VM

1. **Add your user to the vboxsf group:**
   ```bash
   sudo usermod -aG vboxsf $USER
   # Log out and log back in for the group change to take effect
   ```

2. **Verify the shared folder is accessible:**
   ```bash
   # Check if it's mounted
   mount | grep vboxsf
   
   # Or check the default location
   ls -la /media/sf_music
   ```

3. **If not auto-mounted, mount manually:**
   ```bash
   sudo mkdir -p /mnt/windows-music
   sudo mount -t vboxsf music /mnt/windows-music
   # Replace 'music' with your folder name from Step 2
   ```

4. **Make it permanent (if not auto-mounting):**
   ```bash
   # Add to /etc/fstab
   echo "music /mnt/windows-music vboxsf defaults,uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab
   # Adjust uid/gid to match your user (check with: id -u and id -g)
   ```

## Step 4: Update Navidrome Deployment

Update the Navidrome deployment to use the shared folder:

```yaml
volumes:
  - name: music
    hostPath:
      path: /mnt/windows-music  # or /media/sf_music
      type: Directory
```

Let me update your deployment file.
