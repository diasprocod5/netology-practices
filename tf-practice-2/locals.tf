locals {
  vm_names = {
    web = "${var.project}-${var.env}-${var.role}-web"
    db = "${var.project}-${var.env}-${var.role}-db"
  }
}