#Download the image, if an image is already there then it will add a .1 to the end
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

#setup the cloud image hardware settings
qm create 999 --memory 2048 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
qm importdisk 999   noble-server-cloudimg-amd64.img  local
qm set 999 --scsihw virtio-scsi-pci --scsi0 local:999/vm-999-disk-0.raw
qm set 999 --ide2 local:cloudinit
qm set 999 --boot c --bootdisk scsi0
qm set 999 --serial0 socket --vga serial0

#setup QEMU support 
qm set 999 --agent 1

#Genric base OS setup 
qm set 999 --ipconfig0 ip=dhcp
qm set 999 --ciuser liam
qm set 999 --cipassword temppass

#convert to a template
qm set 999 --template 1