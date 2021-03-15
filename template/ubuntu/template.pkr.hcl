source "proxmox" "ubuntu" {
  vm_id                = "${var.vm_id}"

  http_directory       = "${var.http_directory}"
  node                 = "${var.proxmox_node}"
  proxmox_url          = "${var.proxmox_url}"
  username             = "${var.proxmox_username}"
  password             = "${var.proxmox_password}"

  ssh_username         = "${var.ssh_username}"
  ssh_password         = "${var.ssh_password}"
  ssh_timeout          = "${var.ssh_timeout}"

  unmount_iso              = true
  insecure_skip_tls_verify = true

  cloud_init               = true
  cloud_init_storage_pool  = "${var.cloud_init_storage_pool}"

  boot_command             = lookup(local.boot_commands, var.boot_command_type, [])
  boot_wait                = lookup(local.boot_waits, var.boot_command_type, "10s")
  
#  boot_command = [
#    "<esc><wait>",
#    "<esc><wait>",
#    "<enter><wait>",
#    "/install/vmlinuz initrd=/install/initrd.gz",
#    " auto=true priority=critical",
#    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_cfg}",
#    "<enter>"]


  # Options in order of the proxmox menus
  
  # Summary
  template_description = "${var.template_description}"

  # Hardware
  memory          = "${var.vm_memory}"
  cores           = "${var.cores}"
  scsi_controller = "${var.scsi_controller}"

  disks {
    cache_mode        = "unsafe"
    disk_size         = "8G"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm"
    type              = "virtio"
  }

  iso_file        = "${var.iso_filename}"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Options
  vm_name              = "${var.vm_name}"
  os                   = "${var.os}"
  qemu_agent           = true

}

build {
  description = "Build Ubuntu 20.04 (focal) x86_64 Proxmox template"

  sources = ["source.proxmox.ubuntu"]

  provisioner "ansible" {
    #ansible_env_vars = ["ANSIBLE_CONFIG=./playbook/ansible.cfg", "ANSIBLE_FORCE_COLOR=True"]
    extra_arguments  = ["${var.ansible_verbosity}", "--extra-vars", "vm_default_user=${var.ssh_username}", "--tags", "all,is_template", "--skip-tags", "openbsd,alpine"]
    playbook_file    = "ansible/playbook.yml"
    user            = "${var.ssh_username}"
  }

#   post-processor "shell-local" {
#     inline         = ["qm set ${var.vm_id} --scsihw virtio-scsi-pci --serial0 socket --vga serial0"]
#     inline_shebang = "/bin/bash -e"
#   }

}
