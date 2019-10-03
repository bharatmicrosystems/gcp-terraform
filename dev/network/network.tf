module "myvpc" {
  source   = "../../modules/vpc"
  vpc_name = "${var.vpc_name}"
}

module "subnet1"{
  source      = "../../modules/subnet"
  subnet_name = "${var.subnet_name1}"
  subnet_ip_cidr_range = "${var.subnet_ip_cidr_range1}"
  subnet_region = "${var.subnet_region1}"
  network_self_link = "${module.myvpc.network_self_link}"
}

module "subnet2"{
  source      = "../../modules/subnet"
  subnet_name = "${var.subnet_name2}"
  subnet_ip_cidr_range = "${var.subnet_ip_cidr_range2}"
  subnet_region = "${var.subnet_region2}"
  network_self_link = "${module.myvpc.network_self_link}"
}
