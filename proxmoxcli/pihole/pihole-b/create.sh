qm clone 999 121 --name pihole-b --full true --storage local-ssd --target proxmox1

qm set 121 --description "PiHole B"
qm set 121 --cores 1
qm set 121 --memory 2048
qm set 121 --onboot true
pvesm alloc local-ssd 121 vm-121-disk-1 10G

qm set 121 --cicustom "user=snipcustom:snippets/121-pihole-user.yml,network=snipcustom:snippets/121-pihole-network.yml"

qm start 121
