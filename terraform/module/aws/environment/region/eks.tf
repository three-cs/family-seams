
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "14.0.0"
  cluster_name    = local.eks.name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = local.worker_groups
  workers_additional_policies = [ local.eks.worker_policy_arn ]

  tags = local.default_tags

  write_kubeconfig = false

  enable_irsa = true

  # TODO : Windows Solution
  # These commands are used due to https://github.com/aws/containers-roadmap/issues/654
  # The default commands only work on linux like systems, so a 
  #   cross-os solution would need to be written.
  wait_for_cluster_cmd         = "echo"
  wait_for_cluster_interpreter = ["cmd"]

  # Apply any existing fargate roles
  map_roles = [for role in local.fargate_roles : {
    rolearn  = role.Arn
    username = "system:node:{{SessionName}}"
    groups = [
      "system:bootstrappers",
      "system:nodes",
      "system:node-proxier"
    ]
  }]
}

resource "aws_autoscaling_policy" "default_worker_group" {
  for_each = toset([ for wg in local.worker_groups: wg.name ])
  name                   = "${each.value}-policy"
  autoscaling_group_name = each.value
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}

