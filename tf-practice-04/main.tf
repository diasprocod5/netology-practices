module "vpc_network" {
  source = "./modules/vpc"
  network_name = var.vpc_name
  subnets = var.subnets

} 
module "module_vm" {
  source         = var.vm_source
  for_each = {} # var.module_vm
  network_id     = module.vpc_network.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc_network.subnet_ids["${var.default_zone}"]]
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

module "cluster_mysql" {
  source = "./modules/db_cluster"
  cluster_name = var.cluster_config.cluster_name
  network_id = module.vpc_network.network_id
  HA = true
  depends_on = [ module.vpc_network ]
}

module "db_user" {
  source = "./modules/db_app"
  db_name = var.cluster_config.db_name
  user_name = var.cluster_config.user_name
  cluster_id = module.cluster_mysql.cluster_id
}

# s3 Bucket 
module "s3_bucket" {
  source      = "github.com/terraform-yc-modules/terraform-yc-s3"
  bucket_name = "mmr-s3-bucket"
  max_size    = 1073741824
}