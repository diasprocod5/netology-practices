resource "yandex_compute_disk" "disk_vm" {
  count = var.storage_data_disk.count
  name  = "${var.storage_data_disk.name}-${count.index}"
  type  = var.storage_data_disk.disk_type
  size  = var.storage_data_disk.disk_size

}

resource "yandex_compute_instance" "storage" {
  name = var.storage_vm_config.name
  resources {
    cores         = var.storage_vm_config.cores
    memory        = var.storage_vm_config.memory
    core_fraction = var.storage_vm_config.core_fraction
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk_vm
    content {
      disk_id = secondary_disk.value.id
    }
  }
  scheduling_policy {
    preemptible = var.storage_vm_config.preemtible
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.storage_vm_config.disk_size
      type     = var.storage_vm_config.disk_type
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.storage_vm_config.nat
  }

  metadata = {
    ssh-keys = local.ssh_key
  }
}
