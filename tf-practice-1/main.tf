
# TERRAFORM
terraform {
  required_version = "~> 1.16.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.222.0"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

# PROVIDER - YANDEX
provider "yandex" {
  zone = var.yandex_zone
}
# PROVIDER - DOCKER
provider "docker" {
  host = "ssh://mmr@${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}:22"
  ssh_opts = [
    "-i", "~/.ssh/yandex_cloud_ed25519",
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null"
  ]
}

resource "random_password" "mysql_root" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_user" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}



# VAR:ZONE
variable "yandex_zone" {
  description = "Зона доступности Yandex Cloud"
  type        = string
  default     = "ru-central1-a"
}


# DISK
resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = var.yandex_zone
  size     = "30"
  image_id = "fd8stsue5rim479kphah"
}

# NETWORK
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

# SUBNET
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yandex_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# VIRTUAL MACHINE
resource "yandex_compute_instance" "vm-1" {
  name        = "tf01"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  scheduling_policy {
    preemptible = true
  }
  allow_stopping_for_update = true

  # METADATA
  metadata = {
    user-data = file("./meta.txt")
  }
}

# WAIT FOR DOCKER DAEMON INIT
resource "time_sleep" "wait_after_vm_creation" {
  depends_on      = [yandex_compute_instance.vm-1]
  create_duration = "30s"
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = false
  depends_on   = [time_sleep.wait_after_vm_creation]
}


resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql-1"

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root.result}",
    "MYSQL_PASSWORD=${random_password.mysql_user.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wp_user"
  ]
}

# OUTPUT

output "VM_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm-1.name
}

output "external_ip" {
  description = "Публичный IP адрес виртуальной машины"
  value       = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip" {
  description = "Внутренний IP адрес виртуальной машины"
  value       = yandex_compute_instance.vm-1.network_interface.0.ip_address
}


output "get_container_env" {
  description = "Получить список env"
  value       = "ssh -i ~/.ssh/yandex_cloud_ed25519 mmr@${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address} docker exec ${docker_container.mysql.name} env"
}
