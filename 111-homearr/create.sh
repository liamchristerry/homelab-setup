qm clone 999 111 --name homearr --full true --storage local-ssd --target proxmox1

qm set 111 --description "Docker - Home Base"
qm set 111 --cores 2
qm set 111 --memory 2048
qm set 111 --onboot true
pvesm alloc local-ssd 111 vm-111-disk-0 15G

qm set 111 --cicustom "user=snipcustom:snippets/111-homearr-user.yml,network=snipcustom:snippets/111-homearr-network.yml"
qm resize 111 scsi0 15G

qm start 111

sleep 30 # sleep to give the VM time to boot
qm set 111 --cicustom ""
