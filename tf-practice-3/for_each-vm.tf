resource "yandex_compute_instance" "db" {
  for_each    = var.vm_db_config
  name        = each.key
  hostname = each.key
  platform_id = each.value.platform_id
  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }
  scheduling_policy {
    preemptible = each.value.preemtible
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_size
      type     = each.value.disk_type
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = each.value.nat
  }
  metadata = {
    ssh-keys = local.ssh_key
  }
}
