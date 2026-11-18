###cloud vars
/*
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
*/

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
  description = "VPC network&subnet name"
}

# VM WEB vars
variable "vm_web_count" {
  description = "Webserver count"
  type = number
  default = 2
}
variable "vm_web_config" {
  description = "VM WEB common configuration"
  default = {
    name   = "web"
    platform_id   = "standard-v2"
    cores         = 2
    memory        = 2
    core_fraction = 5
    disk_size     = 5
    disk_type     = "network-ssd"
    preemtible    = true
    nat           = true
  }
}

# VM DBs vars
variable "vm_db_config" {
  description = "for_each loop VM variable"
  default = {
    main = {
      platform_id   = "standard-v3"
      disk_type     = "network-hdd"
      cores         = 4
      memory        = 2
      core_fraction = 20
      disk_size     = 5
      preemtible    = true
      nat           = true
    }
    replica = {
    platform_id   = "standard-v1"
    disk_type     = "network-hdd"
    cores         = 2
    memory        = 1
    core_fraction = 5
    disk_size     = 5
    preemtible    = true
    nat           = true
    }
  }
}

# SSH connect vars

variable "login" {
  type = string
  default = "ubuntu"
  description = "default SSH user"
}
variable "ssh_key_path" {
  type = string
  default = "~/.ssh/yandex_cloud_ed25519.pub"
  description = "public ssh key path"
}

# Storage VM vars

variable "storage_vm_config" {
  description = "Storage VM vars"
  default = {
    name   = "storage"
    platform_id   = "standard-v2"
    cores         = 2
    memory        = 2
    core_fraction = 5
    disk_size     = 5
    disk_type     = "network-hdd"
    preemtible    = true
    nat           = false
  }
}

# Storage VM data-disks vars
variable "storage_data_disk" {
  description = "Storage disks config"
  default = {
    name = "storage-data-disk"
    count = 3
    disk_size = 1
    disk_type = "network-hdd"
  }
}