variable "region" {
  description = "Azure Region"
  default     = "westus2"
}

variable "hub-vnet-name" {}
variable "hub-rg-name" {}
variable "hub-vhub-name" {}
variable "hub-vpn-gateway-name" {}
variable "hub-vwan-name" {}
variable "hub-vpn-config-name" {}

variable "hub-cidr" {
  type = list(string)
}
variable "vhub-cidr" {}
variable "hub-p2s-cidr" {}
variable "aad-tenant" {}