variable "iso_filename" {
  type    = string
  default = "${env("iso_filename")}"
}

variable "proxmox_node" {
  type    = string
  default = "${env("proxmox_node")}"
}

variable "proxmox_password" {
  type      = string
  default   = "${env("proxmox_password")}"
  sensitive = true
}

variable "proxmox_url" {
  type    = string
  default = "${env("proxmox_url")}"
}

variable "proxmox_username" {
  type    = string
  default = "root@pam"
}

variable "ssh_password" {
  type      = string
  default   = "${env("ssh_password")}"
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = "${env("ssh_username")}"
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "template_description" {
  type    = string
  default = "Ubuntu 20.04 x86_64 template built with packer (${env("vm_ver")}). Username: ${env("vm_default_user")}"
}

variable "vm_id" {
  type    = string
  default = "${env("vm_id")}"
}

variable "vm_memory" {
  type    = string
  default = "${env("vm_memory")}"
}

variable "vm_name" {
  type    = string
  default = "ubuntu2004-tmpl"
}

variable "ansible_verbosity" {
  type    = string
  default = ""
}

variable "cores" {
  type    = string
  default = "2"
}
variable "cloud_init_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "os" {
  type    = string
  default = "l26"
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-single"
}

variable "preseed_cfg" {
  type    = string
  default = "ubuntu.preseed.cfg"
}

variable "http_directory" {
  type    = string
  default = "http"
}

variable "boot_command_type" {
  type    = string
  default = "ubuntu_cloud_config"
}

variable "eth0_name" {
  type    = string
}

variable "http_config_dir" {
  type    = string
}
variable "http_config_file" {
  type    = string
}

variable "http_config_ip" {
  type    = string
  default = "{{ .HTTPIP }}"
}


locals {
    boot_commands = {
        ubuntu_preseed = [
            "<esc><wait>",
            "<esc><wait>",
            "<enter><wait>",
            "/install/vmlinuz initrd=/install/initrd.gz",
            " auto=true priority=critical",
            " url=http://${var.http_config_ip}:{{ .HTTPPort }}/${var.preseed_cfg}",
            "<enter>"
        ]
        ubuntu_cloud_config = [
            "<enter><enter><f6><esc><wait> ",
            "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/cloud-config/",
            "<enter><wait>"
        ]

        ubuntu_cloud_config2010 = [
            "<esc><wait>e",
            "<down><down><down><end><bs><bs><bs>",
            "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/cloud-config/ ---"
        ]
    }
    boot_waits = {
        ubuntu_preseed      = "10s"
        ubuntu_cloud_config = "5s"
    }

}


