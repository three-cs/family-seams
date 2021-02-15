data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "http" "ingress_controller_crds" {
  url = "https://raw.githubusercontent.com/aws/eks-charts/v0.0.45/stable/aws-load-balancer-controller/crds/crds.yaml"
}

resource "null_resource" "aws_fargate_roles" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "aws iam list-roles --query \"Roles[?contains(RoleName,`fargate`)&&contains(RoleName,`${local.region}`)]\" > ${path.module}/fargate-roles-${local.region}.json"
    interpreter = ["/bin/bash", "-x"]
  }
}

data "local_file" "aws_fargate_roles" {
  depends_on = [null_resource.aws_fargate_roles]
  filename   = "${path.module}/fargate-roles-${local.region}.json"
}