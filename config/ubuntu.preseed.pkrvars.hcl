iso_filename="mnt:iso/ubuntu-20.04.1-legacy-server-amd64.iso"

proxmox_url="https://192.168.178.252:8006/api2/json"
proxmox_node="pve"
proxmox_username="root@pam"
#proxmox_password="DO NOT SET IT HERE"

ssh_username="packer"
#ssh_password="DO NOT SET IT HERE"

# default = "Ubuntu 20.04 x86_64 template built with packer (${env("vm_ver")}). Username: ${env("vm_default_user")}"
template_description="Ubuntu 20.04.2 x86_64 template built with packer" 

#vm_id=999108
vm_memory=4096
vm_name="t-ubuntu-20.04.2-preseed"

#ansible_verbosity="-vvvvvv"
ansible_verbosity="-v"

boot_command_type="ubuntu_preseed"

eth0_name="ens33"
http_config_dir="http"
http_config_file="ubuntu.preseed.cfg"
