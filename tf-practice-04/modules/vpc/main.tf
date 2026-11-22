terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12"
}

resource "yandex_vpc_network" "network" {
  name = var.network_name
}
resource "yandex_vpc_subnet" "subnet" {
  for_each = {for s in var.subnets: s.zone => s}
  name = "${var.network_name}-${substr(each.value.zone,-1,1)}"
  network_id = yandex_vpc_network.network.id
  v4_cidr_blocks = [each.value.cidr]
  zone = each.value.zone
}
