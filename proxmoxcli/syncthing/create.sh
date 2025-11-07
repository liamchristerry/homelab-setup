qm clone 999 155 --name syncthing --full true --storage local-ssd --target proxmox1

qm set 155 --description "syncthing"
qm set 155 --cores 1
qm set 155 --memory 2048
qm set 155 --onboot true
pvesm alloc local-ssd 155 vm-155-disk-1 15G
qm set 155 --scsi1 local-ssd:vm-155-disk-1
pveum pool modify prod-nas --vms 155

qm set 155 --cicustom "user=snipcustom:snippets/155-syncthing-user.yml,network=snipcustom:snippets/155-syncthing-network.yml"

qm resize 155 scsi0 12G
qm resize 155 scsi1 30G

qm start 155
