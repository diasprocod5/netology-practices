resource "yandex_compute_instance" "web" {
  count       = var.vm_web_count
  name        = "${var.vm_web_config.name}-${count.index + 1}"
  platform_id = var.vm_web_config.platform_id

  resources {
    cores         = var.vm_web_config.cores
    memory        = var.vm_web_config.memory
    core_fraction = var.vm_web_config.core_fraction
  }
  scheduling_policy {
    preemptible = var.vm_web_config.preemtible
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_config.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  depends_on = [yandex_compute_instance.db]

  metadata = {
    ssh-keys = local.ssh_key
  }
}
