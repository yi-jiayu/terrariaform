variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

variable "ssh_public_key_file" {
  type        = string
  default     = "id_terraria.pub"
  description = "A path to an SSH public key file to use"
}

variable "server_name" {
  type = string
  default = "Terrariaform"
  description = "Will be displayed in the list of previously-connected servers when connecting in-game"
}

resource "digitalocean_ssh_key" "terraria" {
  name       = "id_terraria"
  public_key = file(var.ssh_public_key_file)
}

resource "digitalocean_droplet" "terraria" {
  image      = "ubuntu-18-04-x64"
  name       = "terraria"
  region     = "sgp1"
  size       = "s-2vcpu-2gb"
  monitoring = true
  ssh_keys   = [digitalocean_ssh_key.terraria.fingerprint]
  user_data = templatefile("cloud-init.yaml", {
    ssh_public_key : digitalocean_ssh_key.terraria.public_key,
    tshock_service_file : filebase64("tshock.service")
  })
}

resource "digitalocean_firewall" "terraria" {
  name = "terraria"

  droplet_ids = [digitalocean_droplet.terraria.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "7777"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "ip" {
  value = digitalocean_droplet.terraria.ipv4_address
}
