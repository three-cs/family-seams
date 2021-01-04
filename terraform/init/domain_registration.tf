
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
      DomainName      = var.domain_name
      DurationInYears = 1
      AutoRenew       = true
      AdminContact = {
        AddressLine1 = "1520 NE 77th Ave"
        # AddressLine2 = 
        City             = "Portland"
        ContactType      = "COMPANY"
        CountryCode      = "US"
        Email            = "family.seams@google.com"
        FirstName        = "Adam"
        LastName         = "Kaplan"
        OrganizationName = "Family Seams"
        PhoneNumber      = "+1.7028135472"
        State            = "OR"
        ZipCode          = "97213"
      }
      RegistrantContact = {
        AddressLine1 = "1520 NE 77th Ave"
        # AddressLine2 = 
        City             = "Portland"
        ContactType      = "COMPANY"
        CountryCode      = "US"
        Email            = "family.seams@google.com"
        FirstName        = "Adam"
        LastName         = "Kaplan"
        OrganizationName = "Family Seams"
        PhoneNumber      = "+1.7028135472"
        State            = "OR"
        ZipCode          = "97213"
      }
      TechContact = {
        AddressLine1 = "1520 NE 77th Ave"
        # AddressLine2 = 
        City             = "Portland"
        ContactType      = "COMPANY"
        CountryCode      = "US"
        Email            = "family.seams@google.com"
        FirstName        = "Adam"
        LastName         = "Kaplan"
        OrganizationName = "Family Seams"
        PhoneNumber      = "+1.7028135472"
        State            = "OR"
        ZipCode          = "97213"
      }
      PrivacyProtectAdminContact      = true
      PrivacyProtectRegistrantContact = true
      PrivacyProtectTechContact       = true
    })
  }
}