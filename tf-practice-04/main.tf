resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "netology" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.default_cidr
}

module "module_vm" {
  source         = var.vm_source
  for_each = var.module_vm
  network_id     = yandex_vpc_network.netology.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.netology.id]
  instance_name  = each.key
  instance_count = each.value.instance_count
  image_family   = each.value.image_family
  public_ip      = each.value.public_ip

  labels = each.value.labels

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yml", {
      vms_ssh_key = var.vms_ssh_root_key
      })
  }
}
