qm clone 999 110 --name kasmhost --full true --storage local-ssd --target proxmox1

qm set 110 --description "Kasm Web OS"
qm set 110 --cores 6
qm set 110 --memory 10240
qm set 110 --onboot true
pvesm alloc local-ssd 110 vm-110-disk-1 15G

qm set 110 --cicustom "user=snipcustom:snippets/110-kasmhost-user.yml,network=snipcustom:snippets/110-kasmhost-network.yml"

qm resize 110 scsi0 50G

qm start 110

sleep 30 # sleep to give the VM time to boot
qm set 110 --cicustom ""
