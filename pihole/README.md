Adding DNS

sudo pihole-FTL --config dns.hosts '["192.168.99.100 pihole.home.lab", "192.168.99.150 nasroms.home.lab", "192.168.99.100 sync.home.lab", "192.168.99.100 kasm.home.lab", "192.168.99.100 proxmox.home.lab"]'
sudo systemctl restart pihole-FTL.service



inventory
[pihole]
192.168.99.120 ansible_user=ansible ansible_ssh_private_key_file=/home/liam/.ssh/id_ed25519
