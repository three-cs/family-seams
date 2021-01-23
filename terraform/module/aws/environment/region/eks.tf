
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = local.eks_cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      name = "default-worker-group"
      instance_type = "t2.small"
      asg_max_size  = 3
      asg_desired_capacity = 1
    }
  ]

  tags = local.default_tags

  write_kubeconfig = false

  # TODO : Windows Solution
  # These commands are used due to https://github.com/aws/containers-roadmap/issues/654
  # The default commands only work on linux like systems, so a 
  #   cross-os solution would need to be written.
  # wait_for_cluster_cmd = ""
  # wait_for_cluster_interpreter = ""
}
