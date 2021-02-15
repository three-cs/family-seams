# Initialization

Steps needed to initialize AWS infrastructure.

## Manual Steps

1. [Create AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
2. Ensure root account has [MFA](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html) setup.
3. Create New Account for API Access.
  * Programmatic Access: true
  * Group: Administrator
  * Tags:
    * organization = family-seams
    * purpose = initialization
  * Setup [aws cli profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) `family-seams`
  * Environment Variables:
    * Windows: 
      ```
      set AWS_PROFILE=family-seams
      set AWS_DEFAULT_REGION=us-west-2
      ```
    * Linux: 
      ```bash
      export AWS_PROFILE=family-seams
      export AWS_DEFAULT_REGION=us-west-2
      ```
  * Verify correct account with: `aws sts get-caller-identity`
4. Create var file for domain registration contact. `contact.tfvars`
    ```hcl
    domain_contact = {
      AddressLine1     = ""
      AddressLine2     = "" # not required
      City             = ""
      ContactType      = ""
      CountryCode      = ""
      Email            = ""
      FirstName        = ""
      LastName         = ""
      OrganizationName = ""
      PhoneNumber      = ""
      State            = ""
      ZipCode          = ""
    }
    ```

## Terraform Steps

No workspaces are needed for initialization since this infrastrucutre is 
used for all future terraform.

```bash
terraform init

terraform apply -var-file=contact.tfvars
```