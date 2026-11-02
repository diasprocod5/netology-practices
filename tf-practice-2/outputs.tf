output "name" {
  description = "Параметры виртуальных машин"
  value = {
    vm_web_name        = yandex_compute_instance.platform.name
    vm_web_external_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address
    vm_web_fqdn        = yandex_compute_instance.platform.fqdn

    vm_db_name        = yandex_compute_instance.platform_db.name
    vm_db_external_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
    vm_db_fqdn        = yandex_compute_instance.platform_db.fqdn
  }
}
