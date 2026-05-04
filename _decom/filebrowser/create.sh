qm clone 999 111 --name filebrowser --full true --storage local-ssd --target proxmox1

qm set 111 --description "Web File Browser"
qm set 111 --cores 2
qm set 111 --memory 2048
qm set 111 --onboot true
pvesm alloc local-ssd 111 vm-111-disk-0 15G

qm set 111 --cicustom "user=snipcustom:snippets/111-filebrowser-user.yml,network=snipcustom:snippets/111-filebrowser-network.yml"

qm start 111
