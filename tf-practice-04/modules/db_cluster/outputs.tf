output "cluster_id" {
  description = "MYSQL cluster id"
  value = yandex_mdb_mysql_cluster.my_cluster.id
}