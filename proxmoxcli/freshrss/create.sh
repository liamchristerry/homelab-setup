qm clone 999 113 --name freshrss --full true --storage local-ssd --target proxmox1

qm set 113 --description "Docker - Local RSS Feed Reader"
qm set 113 --cores 2
qm set 113 --memory 2048
qm set 113 --onboot true
qm resize 113 scsi0 12G

qm set 113 --cicustom "user=snipcustom:snippets/113-freshrss-user.yml,network=snipcustom:snippets/113-freshrss-network.yml"

qm start 113
