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

## Quickstart

1. Create a new SSH key pair called `id_terraria`: `ssh-keygen -f id_terraria
   -t ed25519 -N '' -C ''`
2. Run `terraform init`.
3. Copy `terraform.tfvars.template` to `terraform.tfvars`: `cp
   terraform.tfvars.template terraform.tfvars`.
4. Add your DigitalOcean personal access token to `terraform.tfvars`.
5. Run `terraform apply`. This will output the server's IP address when
   complete.
6. Monitor the server setup using `ssh -i id_terraria terraria@$(terraform
   output ip) tail -f /var/log/cloud-init-output.log`. The setup is complete
   once you see a line starting with `Cloud-init ... finished`.
7. At this point, TShock should have started and will take some time to create
   a new world.
8. Launch Terraria and connect to the server at its IP address on port 7777.

## Managing your server

To connect to the server, run `ssh -i id_terraria terraria@$(terraform output
ip)` from the project directory.

To interact with the TShock process, run `screen -r tshock` on the server. You
can do this to see the auth code for becoming a super admin.

Hit <kbd>Control</kbd> + <kbd>A</kbd> and then <kbd>D</kbd> to detach from the
screen without stopping the TShock process.
