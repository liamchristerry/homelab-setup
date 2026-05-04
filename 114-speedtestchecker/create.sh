qm clone 999 114 --name speedtestchecker --full true --storage local-ssd --target proxmox1

qm set 114 --description "Docker - Local Speed Tests"
qm set 114 --cores 2
qm set 114 --memory 2048
qm set 114 --onboot true
pvesm alloc local-ssd 114 vm-114-disk-0 15G

qm set 114 --cicustom "user=snipcustom:snippets/114-speedtestchecker-user.yml,network=snipcustom:snippets/114-speedtestchecker-network.yml"
qm resize 114 scsi0 15G

qm start 114

sleep 30 # sleep to give the VM time to boot
qm set 114 --cicustom ""
