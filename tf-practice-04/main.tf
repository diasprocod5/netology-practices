module "vpc_network" {
  source = "./modules/vpc"
  network_name = var.vpc_name
  subnets = [
    { zone = var.default_zone, cidr = join("",var.default_cidr) },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.0.3.0/24" },
  ]
}
module "module_vm" {
  source         = var.vm_source
  for_each = var.module_vm
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
