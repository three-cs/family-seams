

data "terraform_remote_state" "init" {
  backend = "local"

  config = {
    path = "${path.module}/../init/state/init.tfstate"
  }
}