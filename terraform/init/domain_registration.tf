
resource "null_resource" "docker_build" {
  triggers = { for file in fileset("${path.module}/docker", "**") : file => filemd5("${path.module}/docker/${file}") }

  provisioner "local-exec" {
    command = "docker build -t aws-scripts ${path.module}/docker"
  }
}

data "external" "registered_domain" {
  depends_on = [null_resource.docker_build]

  program = [
    "docker", "run",
    "-v", "${pathexpand("~/.aws")}:/root/.aws",
    "-e", "AWS_PROFILE",
    "-e", "AWS_DEFAULT_REGION",
    "--rm",
    "-i",
    "aws-scripts",
    "register-domain.bash"
  ]

  query = {
    # 30 minutes to wait for registration timeout
    registration_timeout = 30 * 60
    registration = jsonencode({
      DomainName                      = var.domain_name
      DurationInYears                 = 1
      AutoRenew                       = true
      AdminContact                    = local.domain_contact
      RegistrantContact               = local.domain_contact
      TechContact                     = local.domain_contact
      PrivacyProtectAdminContact      = true
      PrivacyProtectRegistrantContact = true
      PrivacyProtectTechContact       = true
    })
  }
}