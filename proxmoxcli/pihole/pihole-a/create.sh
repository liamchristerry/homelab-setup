qm clone 999 120 --name pihole-a --full true --storage local-ssd --target proxmox1

qm set 120 --description "PiHole A"
qm set 120 --cores 1
qm set 120 --memory 2048
qm set 120 --onboot true
pvesm alloc local-ssd 120 vm-120-disk-1 10G

qm set 120 --cicustom "user=snipcustom:snippets/120-pihole-user.yml,network=snipcustom:snippets/120-pihole-network.yml"

qm start 120
