# Create User CloudInit Config


```
qm cloudinit dump 999 user > ubuntu-base.yml
mv ubuntu-base.yml /mnt/snipcustom/snippets/
qm set 999 --cicustom "user=snipcustom:snippets/ubuntu-base.yml"
```

## Sample User CloudInit

```
#cloud-config
hostname: ubuntu-cloud
manage_etc_hosts: true
fqdn: ubuntu-cloud
user: liam
password: $5$ABbS/nHGmDe8tDSFOsaasdPsdsdfhtxsROAq0Rvrgl7nKII6R1M19ZD
chpasswd:
  expire: False
users:
  - default
package_upgrade: true
packages:
  - qemu-guest-agent
runcmd:
  - systemctl start qemu-guest-agent
  - systemctl enable qemu-guest-agent
  - echo "job done" >> /home/liam/testing
```

# Access into VMs
- SSH for ansible user
  - SSH key is on WSL instance
- Password for liam user, see below how to generate a hash password
  - Not security best pratice. Need to move to Ansible to manage secerts
```
mkpasswd -m sha-512 "MyPassword123"
```

# Useful Commands
```
#shows you the config of the VM. includes Cloudinit settings
qm config 999

#dump the VM cloudinit settings. If you have a custom CI then these are overwritten
qm cloudinit dump 100 user
qm cloudinit dump 100 network
qm cloudinit dump 100 meta

#set Template back to VM
qm set <vid> --template 0
```

## Tips
- you have to have the cloud init drive even if you use the cicustom stuff
- the gui will not update with Cloudinit settings if you are using a cicustom. 
- Logs
    - /run/cloud/
    - /var/logs/cloudinit output was good
- About disk importing 
    - https://commandmasters.com/commands/qm-disk-import-linux/


# QM Set - Commands
You can use these commands below to set IP address if you dont want to set with CloudInit
```
qm set 150 --ipconfig0 ip=192.168.99.150/24,gw=192.168.99.1
qm set 150 --nameserver "8.8.8.8 1.1.1.1"
```


## DNS and IPs
- nginxrp - .100
- kasmhost - .110
  - kasm.home.lab
- homearr - .111
  - home.lab:7575
- openspeedtest - .112
  - speedtest.home.lab
- nginxvualt - .113
  - vault.home.lab
- speedtestchecker - .114
  - 
- uptimekuma - .115
  - up.home.lab
- tailscale - .116

- synlogy - .200
  - synology.home.lab
- truenas - .201
  - truenas.home.lab
- dell 1 - .211
  - proxmox1.home.lab
- dell 2 - .212
  - proxmox2.home.lab
- dell 3 - .213
  - promox3.home.lab


- plex.home.lab
- file.home.lab
- syncthing.home.lab


expand drives
```
pvesm alloc local-ssd VMID vm-VMID-disk-1 15G
qm resize VMID scsi0 15G

# Reboot VM and it should auto expand
```




