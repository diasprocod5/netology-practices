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
  default     = "netology"
  description = "VPC network&subnet name"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

# Module vm source
variable "vm_source" {
  description = "VMs create remote module source"
  type        = string
  default     = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=v2.1.0"
  const = true
}

# Module vm config

variable "module_vm" {
  description = "remote module VMs config"
  type = map(object({
    instance_count = optional(number, 1)
    image_family   = optional(string, "ubuntu-2004-lts")
    public_ip      = optional(bool, true)
    env_name       = optional(string, "netology")
    labels         = optional(map(string), {})
  }))
  default = {
    marketing = {
      labels = {
        project = "marketing"
      }
    }
    analytics = {
      labels = {
        project = "analytics"
      }
    }
  }
}

variable "subnets" {
  type = list(object({
    zone = string
    cidr = string
  }))
  default = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-e", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.0.3.0/24" }
    ]
}

# mysql cluster vars
variable "cluster_config" {
  type = object({
    cluster_name = string
    db_name = string
    user_name = string
  })
  default = {
    cluster_name = "mysql_cluter"
    db_name = "mysql_db"
    user_name = "mysql_user"
  }
}


