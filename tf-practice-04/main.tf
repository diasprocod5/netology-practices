module "vpc_network" {
  source = "./modules/vpc"
  zone = var.default_zone
  network_name = var.vpc_name
  cidr = var.default_cidr
}
module "module_vm" {
  source         = var.vm_source
  for_each = var.module_vm
  network_id     = module.vpc_network.network_id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc_network.subnet_id]
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
