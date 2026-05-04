qm clone 999 116 --name tailscale --full true --storage local-ssd --target proxmox1

qm set 116 --description "Tailscale remote VPN/Mesh"
qm set 116 --cores 1
qm set 116 --memory 2048
qm set 116 --onboot true
pvesm alloc local-ssd 116 vm-116-disk-1 15G

qm set 116 --cicustom "user=snipcustom:snippets/116-tailscale-user.yml,network=snipcustom:snippets/116-tailscale-network.yml"

qm resize 116 scsi0 15G

qm start 116

sleep 30 # sleep to give the VM time to boot
qm set 116 --cicustom ""



