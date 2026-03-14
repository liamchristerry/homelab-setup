qm clone 999 113 --name nginxvault --full true --storage local-ssd --target proxmox1

qm set 113 --description "Nginx Server to store local only secrets"
qm set 113 --cores 2
qm set 113 --memory 2048
qm set 113 --onboot true
pvesm alloc local-ssd 113 vm-113-disk-0 15G

qm set 113 --cicustom "user=snipcustom:snippets/113-nginxvault-user.yml,network=snipcustom:snippets/113-nginxvault-network.yml"

qm start 113
