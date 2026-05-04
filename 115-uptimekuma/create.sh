qm clone 999 115 --name uptimekuma --full true --storage local-ssd --target proxmox1

qm set 115 --description "Docker - Uptime Monitor"
qm set 115 --cores 2
qm set 115 --memory 2048
qm set 115 --onboot true
pvesm alloc local-ssd 115 vm-115-disk-0 15G

qm set 115 --cicustom "user=snipcustom:snippets/115-uptimekuma-user.yml,network=snipcustom:snippets/115-uptimekuma-network.yml"
qm resize 115 scsi0 15G

qm start 115

sleep 30 # sleep to give the VM time to boot
qm set 115 --cicustom ""
