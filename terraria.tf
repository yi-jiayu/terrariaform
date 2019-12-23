variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

variable "ssh_public_key_file" {
  type = string
}

resource "digitalocean_ssh_key" "terraria" {
  name       = "id_terraria"
  public_key = file(var.ssh_public_key_file)
}

resource "digitalocean_droplet" "terraria" {
  image  = "ubuntu-18-04-x64"
  name   = "terraria"
  region = "sgp1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.terraria.fingerprint]
  user_data = templatefile("cloud-init.yaml", { ssh_public_key = file(var.ssh_public_key_file) })
}

output "ip" {
  value = digitalocean_droplet.terraria.ipv4_address
}