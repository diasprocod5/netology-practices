###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_public_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519 (public)"
}

# compute image & compute instance vars
variable "vm_web_image_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "yandex compute image family"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
  description = "virtual machine name"
}
variable "vm_web_platform_id" {
  type = string
  default = "standard-v2"
  description = "yandex platform id"
}

variable "vm_web_cores" {
  type = number
  default = 2
  description = "compute cores"
}
variable "vm_web_memory" {
  type = number
  default = 1
  description = "compute memory"
}

variable "vm_web_core_fraction" {
  type = number
  default = 5
  description = "compute core fraction (%)"
}

variable "vm_web_preemptible" {
  type = bool
  default = true
  description = "is preemptible"
}

variable "vm_web_nat" {
  type = bool
  default = true
  description = "enable NAT"
}

variable "vm_web_serial_port_enable" {
  type = number
  default = 1
  description = "is serial-port-enable: 0 or 1"
}