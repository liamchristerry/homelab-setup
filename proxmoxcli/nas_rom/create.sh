qm clone 999 150 --name nasroms --full true --storage local-ssd --target proxmox1

qm set 150 --description "NAS / ROM Storage"
qm set 150 --cores 1
qm set 150 --memory 2048
qm set 150 --onboot true
pvesm alloc local-ssd 150 vm-150-disk-1 10G
qm set 150 --scsi1 local-ssd:vm-150-disk-1
pveum pool modify prod-nas --vms 150

qm set 150 --cicustom "user=snipcustom:snippets/150-nasroms-user.yml,network=snipcustom:snippets/150-nasroms-network.yml"

qm resize 150 scsi0 15G

qm start 150
