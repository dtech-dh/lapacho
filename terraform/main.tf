terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}
variable "ssh_key_id" {}
variable "droplet_name" { default = "lapacho" }
variable "region" { default = "nyc3" }
variable "size" { default = "s-2vcpu-2gb" }

resource "digitalocean_droplet" "infra" {
  image  = "ubuntu-22-04-x64"
  name   = var.droplet_name
  region = var.region
  size   = var.size
  ssh_keys = [var.ssh_key_id]
}

output "droplet_ip" {
  value = digitalocean_droplet.infra.ipv4_address
}
