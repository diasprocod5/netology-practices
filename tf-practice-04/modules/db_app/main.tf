terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12"
}
resource "random_password" "user_passsword" {
  length  = 16
  special = false
}

resource "yandex_mdb_mysql_database" "app_db" {
  cluster_id = var.cluster_id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "app_user" {
  cluster_id = var.cluster_id
  name       = var.user_name
  password   = random_password.user_passsword.result

  permission {
    database_name = yandex_mdb_mysql_database.app_db.name
    roles         = ["ALL"]
  }
}
