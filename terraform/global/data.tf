data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "init" {
  backend = "local"

  config = {
    path = "${path.module}/../init/state/init.tfstate"
  }
}