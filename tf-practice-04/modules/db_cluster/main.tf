terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12"
}

data "yandex_vpc_network" "netology" {
  network_id =var.network_id
}
data "yandex_vpc_subnet" "netology" {
  count = var.HA ? 2: 1
  subnet_id = data.yandex_vpc_network.netology.subnet_ids[count.index]
}

resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = var.cluster_name
  network_id  = var.network_id
  version     = var.cluster_version
  environment = var.environment.dev

  resources {
    resource_preset_id = var.resources.resource_preset_id
    disk_type_id       = var.resources.disk_type_id
    disk_size          = var.resources.disk_size
  }


  dynamic "host" {
    for_each = data.yandex_vpc_subnet.netology
    content {
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
    }
  }
}
