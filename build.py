#!/usr/bin/env python3
# Written in python and not in bash, because python runs on windows and linux
import re
import os
import jinja2
from types import SimpleNamespace
import crypt

config_dir= "config"
target_os = "ubuntu"
varfile   = target_os + ".preseed.pkrvars.hcl" 
#varfile   = target_os + ".cloud-config.pkrvars.hcl" 
vm_id="999115"

def load_variables(filename, var_hash):
    regex='[ |\t]*(^[a-z][a-zA-Z0-9_]*)[ |\t]*=[ |\t]*"([^"]+)'
    f = open(filename, "r")
    lines=f.readlines()
    f.close()
    
    for line in lines:
        z = re.match(regex, line)
        if z:
            groups    = z.groups()
            var_name  = groups[0]
            var_value = groups[1]
            var_hash[var_name] = var_value
    return var_hash


def env(name):
    return os.environ[name]

def env_exists(name):
    if name in os.environ:
        return True
    return False


def from_template(searchpath, template_file, template_context):
    template_loader = jinja2.FileSystemLoader(searchpath=searchpath)
    template_env    = jinja2.Environment(
        loader=template_loader
#        trim_blocks=True,
#        lstrip_blocks=False
    )
    template_env.globals['env'] = env
    template_env.globals['env_exists'] = env_exists

    template = template_env.get_template(template_file)
    output_text = template.render(template_context)
    return output_text

def write_content(filename, content):
   f = open(filename, "w")
   f.write(content)
   f.close()

def assign(var_name, var_hash, salt=None):
    if var_name in os.environ:
        var_hash[var_name] = os.environ[var_name]
    
    if var_name in var_hash:
        os.environ[var_name] = var_hash[var_name]
        var_hash[var_name + "_hash"] = crypt.crypt(var_hash[var_name], salt)


filename = os.path.join(config_dir, varfile )

var_hash = {"salt": None}
var_hash = load_variables(filename, var_hash)

passwd_file = os.path.join(os.path.dirname(os.path.abspath(__file__)),".passwd.cfg")
if os.path.isfile(passwd_file):
    var_hash = load_variables(passwd_file, var_hash)

# you can override root_password with environment variables
salt = var_hash['salt']
assign('root_password', var_hash, salt)
assign('ssh_password', var_hash, salt)

if not 'proxmox_password' in os.environ:
    if 'proxmox_password' in var_hash:
        os.environ['proxmox_password'] = var_hash['proxmox_password']

# hash to namespace
os.environ['vm_id'] = vm_id

template_hash = {}


template_dir =var_hash['http_config_dir']
template_name=var_hash['http_config_file']

content = from_template(template_dir, template_name + ".j2", var_hash)
target_filename = os.path.join(template_dir, template_name)
write_content(target_filename, content)
#print(content)
#exit(0)

packer = os.path.join("..", "packer", "packer")

cmdline= packer + " build -var-file " + str(os.path.join(config_dir, varfile)) + " " + str(os.path.join("template", target_os))
print(cmdline)
os.system(cmdline)
