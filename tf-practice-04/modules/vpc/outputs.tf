output "network_id" {
  description = "ID созданной сети"
  value       = yandex_vpc_network.network.id
}
output "subnet_ids" {
  description = "Map {zone: id}"
  value       = { for zone, s in yandex_vpc_subnet.subnet : zone => s.id }
}

