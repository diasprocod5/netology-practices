variable "HA" {
  description = "Включить высокую доступность"
  type = bool
  default = false
}
variable "cluster_name" {
  type = string
}
variable "network_id" {
  type = string
}

variable "cluster_version" {
  type = string
  description = "cluster version"
  default = "8.0"
}
variable "environment" {
  type = object({
    prod = string
    dev = string
  })
  default = {
    prod = "PRODUCTION"
    dev = "PRESTABLE"
  }
}
variable "resources" {
  type = object({
    resource_preset_id = string
    disk_type_id = string
    disk_size = number
  })
  default = {
    resource_preset_id = "s2.micro"
    disk_type_id = "network-ssd"
    disk_size = 20
  }
}


