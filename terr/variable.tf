variable "db_password" {

  default = "kris2000"

}

variable "env" {

  default = "dev"

}

variable "region" {

  default = "us-east-1"

}

variable "zone1" {

  default = "us-east-1a"

}

variable "zone2" {

  default = "us-east-1b"

}

variable "eks_name" {

  default = "szakd"

}

variable "eks_version" {

  default = "1.32"

}

variable "cidr_block" {

  default = "10.0.0.0/16"

}

variable "enable_dns_support" {

  type    = bool
  default = true

}

variable "enable_dns_hostnames" {

  type    = bool
  default = true

}

variable "map_public_ip_on_launch" {

  type    = bool
  default = true

}

variable "domain" {

  default = "vpc"

}


variable "cidr_block_pub1" {

  default = "10.0.0.0/24"

}


variable "cidr_block_pub2" {

  default = "10.0.1.0/24"

}


variable "cidr_block_priv1" {

  default = "10.0.2.0/24"

}


variable "cidr_block_priv2" {

  default = "10.0.3.0/24"

}

variable "cidr_block_route" {

  default = "0.0.0.0/0"

}

variable "authentication_mode" {

  default = "API"

}

variable "bootstrap_cluster_creator_admin_permissions" {

  type    = bool
  default = true

}

variable "endpoint_private_access" {

  type    = bool
  default = false

}

variable "endpoint_public_access" {

  type    = bool
  default = true

}

variable "node_group_name" {

  default = "worker-node"

}


variable "instance_types" {

  type    = string
  default = "t3.small"


}

variable "role" {

  default = "szakd-node"
}

variable "instance_class" {

  default = "db.t3.micro"

}

variable "engine" {

  default = "postgres"

}

variable "username" {

  default = "djangouser"

}

variable "engine_version" {

  default = "15"

}

variable "db_name" {

  default = "postgres"

}

variable "port" {

  default = 5432
}

variable "allocated_storage" {

  default = 10

}

variable "multi_az" {

  type    = bool
  default = true

}

variable "publicly_accessible" {

  type    = bool
  default = false

}

variable "skip_final_snapshot" {

  type    = bool
  default = true

}

variable "protocol" {

  default = "tcp"
}

variable "karpenter_version" {
  default = "1.3.3"
}

variable "karpenter_namespace" {
  default = "karpenter"
}

variable "argocd_namespace" {
  default = "argocd"
}


variable "argocd_version" {
  default = "2.14.9"
}