
ansible-playbook -e packer_build_name="ubuntu" -e packer_builder_type=proxmox --ssh-extra-args '-o IdentitiesOnly=yes' -vvvvvv --extra-vars vm_default_user=packer --tags all,is_template --skip-tags openbsd,alpine -i testing/inventory.yaml ansible/playbook.yml -e ansible_user=packer --ask-pass
