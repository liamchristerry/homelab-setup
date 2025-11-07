# In proxmox 
qm resize 155 scsi1 30G

# Ansible Playbook
---
- name: Expand partition and filesystem on /dev/sdb1
  hosts: syncthing
  become: yes
  tasks:

    - name: Ensure growpart tool is installed
      ansible.builtin.package:
        name: cloud-guest-utils
        state: present

    - name: Resize partition /dev/sdb1 to fill disk
      ansible.builtin.command: growpart /dev/sdb 1
      register: growpart_result
      failed_when: growpart_result.rc not in [0, 1]
      changed_when: "'CHANGED' in growpart_result.stdout"

    - name: Expand XFS filesystem on /mnt/nfs
      ansible.builtin.command: xfs_growfs -d /mnt/nfs
      register: growfs_result
      changed_when: "'data blocks changed' in growfs_result.stdout"





inventory
[syncthing]
192.168.99.155 ansible_user=ansible ansible_ssh_private_key_file=/home/liam/.ssh/id_ed25519

