# Homelab Ansible Automation

Ansible playbooks for deploying and managing a Proxmox-based homelab with LXC containers.

## Structure

```
ansible/
├── create/          # Playbooks to create LXC containers
├── configure/       # Playbooks to configure services
├── deploy/          # Combined create + configure playbooks
├── tasks/           # Reusable task files
├── templates/       # Jinja2 templates for configs
├── inventory/       # Inventory files
├── group_vars/      # Global variables
└── ansible.cfg      # Ansible configuration
```

## Prerequisites

1. **Install Ansible and required collections:**
   ```bash
   # Install Ansible
   sudo apt update
   sudo apt install ansible

   # Install required collections
   ansible-galaxy collection install community.general
   ```

2. **Download LXC template on Proxmox host:**
   ```bash
   ssh root@192.168.99.211
   pveam update
   pveam download local ubuntu-22.04-standard_22.04-1_amd64.tar.zst
   ```

3. **Configure your environment:**
   ```bash
   # Edit group_vars/all.yml with your settings
   vim group_vars/all.yml

   # Update IPs, hostnames, SSH keys, etc.
   ```

4. **Create secrets file:**
   ```bash
   # Copy example and fill in your passwords
   cp secrets.yml.example secrets.yml
   vim secrets.yml

   # Encrypt it
   ansible-vault encrypt secrets.yml
   ```

5. **Generate password hash for admin user:**
   ```bash
   # Install mkpasswd
   sudo apt install whois

   # Generate hash
   mkpasswd --method=sha-512

   # Put the output in group_vars/all.yml under admin_password_hash
   ```

## Usage

### Deploy Individual Services

```bash
# Deploy nginx (create + configure)
ansible-playbook deploy/nginx.yml -e @secrets.yml --ask-vault-pass

# Deploy Pi-hole
ansible-playbook deploy/pihole.yml -e @secrets.yml --ask-vault-pass

# Deploy Authelia
ansible-playbook deploy/authelia.yml -e @secrets.yml --ask-vault-pass

# Deploy Cloudflare Tunnel
ansible-playbook deploy/cloudflare-tunnel.yml -e @secrets.yml --ask-vault-pass
```

### Deploy Entire Stack

```bash
ansible-playbook deploy/all.yml -e @secrets.yml --ask-vault-pass
```

### Run Create or Configure Separately

```bash
# Just create the container (no configuration)
ansible-playbook create/nginx.yml -e @secrets.yml --ask-vault-pass

# Just configure existing container (no recreation)
ansible-playbook configure/nginx.yml -e @secrets.yml --ask-vault-pass
```

## Service Definitions

Edit `group_vars/all.yml` to customize:
- VM IDs
- IP addresses
- Resource allocation (CPU, RAM, disk)
- Network settings
- Base packages

## Customization

### Add a New Service

1. **Add service to `group_vars/all.yml`:**
   ```yaml
   services:
     myservice:
       vmid: 140
       hostname: myservice
       ip: 192.168.99.140
       cores: 2
       memory: 2048
       disk: 8
   ```

2. **Create `create/myservice.yml`:**
   ```yaml
   ---
   - name: Create MyService LXC Container
     hosts: localhost
     gather_facts: no
     vars:
       service_name: myservice
     tasks:
       - name: Create myservice LXC on Proxmox
         include_tasks: ../tasks/create-lxc.yml
   ```

3. **Create `configure/myservice.yml`:**
   ```yaml
   ---
   - name: Configure MyService
     hosts: myservice
     become: yes
     tasks:
       - name: Apply base LXC configuration
         include_tasks: ../tasks/base-lxc-config.yml
       
       - name: Install myservice
         apt:
           name: myservice
           state: present
   ```

4. **Create `deploy/myservice.yml`:**
   ```yaml
   ---
   - import_playbook: ../create/myservice.yml
   - import_playbook: ../configure/myservice.yml
   ```

5. **Add to inventory:**
   ```ini
   [myservice]
   myservice ansible_host=192.168.99.140
   ```

## Common Tasks

### Reconfigure a Service

```bash
# Only run configuration (no container recreation)
ansible-playbook configure/nginx.yml
```

### Destroy and Recreate

```bash
# Manually destroy container on Proxmox
ssh root@192.168.99.211
pct destroy 100

# Deploy fresh
ansible-playbook deploy/nginx.yml -e @secrets.yml --ask-vault-pass
```

### Update All Containers

Create `day2/update-all.yml`:
```yaml
---
- name: Update all LXC containers
  hosts: proxmox
  become: yes
  tasks:
    - name: Get running containers
      shell: "pct list | awk 'NR>1 && $2==\"running\" {print $1}'"
      register: containers
      changed_when: false
    
    - name: Update each container
      command: "pct exec {{ item }} -- bash -c 'apt update && apt upgrade -y'"
      loop: "{{ containers.stdout_lines }}"
```

Run it:
```bash
ansible-playbook day2/update-all.yml
```

## Troubleshooting

### Connection Issues

```bash
# Test connectivity
ansible all -m ping

# Verify inventory
ansible-inventory --list

# Check specific host
ansible nginx -m command -a "hostname"
```

### Playbook Errors

```bash
# Run with verbose output
ansible-playbook deploy/nginx.yml -vvv

# Check syntax
ansible-playbook deploy/nginx.yml --syntax-check

# Dry run
ansible-playbook deploy/nginx.yml --check
```

### Container Not in Inventory

After creating a container, if it's not accessible:
1. Check the container is running: `pct list`
2. Verify IP: `pct exec 100 -- ip addr`
3. Test SSH: `ssh liam@192.168.99.100`
4. Check inventory file has correct IP

## Security Notes

- **Never commit `secrets.yml`** - add to `.gitignore`
- Use Ansible Vault for all passwords
- Change default passwords immediately
- Configure firewall rules on containers
- Keep systems updated regularly

## Resources

- [Proxmox LXC Documentation](https://pve.proxmox.com/wiki/Linux_Container)
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Proxmox Module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_module.html)

## License

MIT