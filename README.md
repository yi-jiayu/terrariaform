# Terraria server
[Terraform](https://www.terraform.io/) project for deploying a
[Terraria](https://terraria.org/) server running
[TShock](https://tshock.co/xf/index.php) on
[DigitalOcean](https://www.digitalocean.com/)

## Prerequisites

You should have:

1. Terraform already set up
   (https://learn.hashicorp.com/terraform/getting-started/install.html)
2. A DigitalOcean personal access token
   (https://www.digitalocean.com/docs/api/create-personal-access-token/)
3. An SSH key pair which you have not already added to DigitalOcean (you can
   create one using `ssh-keygen -f id_terraria -t ed25519 -N '' -C ''`)

## Quickstart

1. Run `terraform init` in the project directory.
2. Copy `terraform.tfvars.template` to `terraform.tfvars`: `cp
   terraform.tfvars.template terraform.tfvars`.
3. Add your DigitalOcean personal access token and path to your SSH public key
   to `terraform.tfvars`.
4. Run `terraform apply` and take note of the IP address it outputs when
   complete.
5. Wait for a while after `terraform apply` completes for the server to be
   ready.
6. Connect to the server at its IP address on port 7777.

## Managing your server

`terraform apply` will output the IP address of the newly created server. You
can connect to it using the SSH key pair you provided, for example with `ssh -i
id_terraria root@$(terraform output ip)`.

The server setup commands will still be running after `terraform apply`
completes. While connected to the droplet, you can monitor the setup process
using `less +F /var/log/cloud-init-output.log`.

Once done, the TShock server itself will be running inside a screen session
managed by systemd. A new small world will automatically be generated the first
time it starts. To interact with the TShock process, you have to attach to the
screen session as the `terraria` user: `sudo -u terraria screen -r terraria`.

