qm clone 999 100 --name nginxrp --full true --storage local-ssd --target proxmox1

qm set 100 --description "NAS / ROM Storage"
qm set 100 --cores 1
qm set 100 --memory 2048
qm set 100 --onboot true
pvesm alloc local-ssd 100 vm-100-disk-1 15G

qm set 100 --cicustom "user=snipcustom:snippets/100-nginxrp-user.yml,network=snipcustom:snippets/100-nginxrp-network.yml"

qm resize 100 scsi0 15G

qm start 100

sleep 30 # sleep to give the VM time to boot
qm set 100 --cicustom ""



