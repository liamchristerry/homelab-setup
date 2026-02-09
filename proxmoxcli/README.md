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
password: $5$ABbS/nH/$jEGmDe8tDSFOPhtxbE9sROAq0Rvrgl7nKII6R1M19ZD
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
