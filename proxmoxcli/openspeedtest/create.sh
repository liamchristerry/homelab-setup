qm clone 999 112 --name openspeedtest --full true --storage local-ssd --target proxmox1

qm set 112 --description "Docker - Local Speed Tests"
qm set 112 --cores 2
qm set 112 --memory 2048
qm set 112 --onboot true
pvesm alloc local-ssd 112 vm-112-disk-0 15G

qm set 112 --cicustom "user=snipcustom:snippets/112-openspeedtest-user.yml,network=snipcustom:snippets/112-openspeedtest-network.yml"

qm start 112
