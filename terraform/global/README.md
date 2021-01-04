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
    * Set default profile.
      * Windows: `set AWS_PROFILE=family-seams`
      * Linux: `export AWS_PROFILE=family-seams`
    * Set default region.
      * Windows: `set AWS_DEFAULT_REGION=us-west-2`
      * Linux: `export AWS_DEFAULT_REGION=us-west-2`
  * Verify correct account with: `aws sts get-caller-identity`

## Terraform Steps

No workspaces are needed for initialization since this infrastrucutre is 
used for all future terraform.

```
terraform init

terraform apply
```