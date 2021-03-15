# https://www.aerialls.io/posts/ubuntu-server-2004-image-packer-subiquity-for-proxmox/

#iso_filename="mnt:iso/ubuntu-20.10-live-server-amd64.iso"
#iso_filename="mnt:iso/ubuntu-20.04.1-live-server-amd64.iso"
iso_filename="mnt:iso/ubuntu-20.04.2-live-server-amd64.iso"

proxmox_url="https://192.168.178.252:8006/api2/json"
proxmox_node="pve"
proxmox_username="root@pam"
#proxmox_username="packer@pam"
#proxmox_password="DO NOT SET IT HERE"

ssh_username="packer"
#ssh_password="DO NOT SET IT HERE"

# default = "Ubuntu 20.04 x86_64 template built with packer (${env("vm_ver")}). Username: ${env("vm_default_user")}"
template_description="Ubuntu 20.04 x86_64 template built with packer" 


#vm_id=999108
vm_memory=4096
vm_name="t-ubuntu-20.04.2"

#ansible_verbosity="-vvvvvv"
ansible_verbosity="-v"

boot_command_type="ubuntu_cloud_config"

eth0_name="ens18"
http_config_dir="http/cloud-config"
http_config_file="ubuntu.preseed.cfg"
