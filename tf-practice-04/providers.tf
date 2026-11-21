terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.12"
}

provider "yandex" {
  service_account_key_file = file("service_account_key.json")
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}