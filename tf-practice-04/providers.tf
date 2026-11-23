terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.1"
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

provider "aws" {
  region                      = "ru-central1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
}
