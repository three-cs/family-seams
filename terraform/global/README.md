# Global

Terraform to create globally used resources.  All defined resources are 
expected to be useable by all environments.

## Manual Steps

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

## Terraform Steps

No workspaces are needed for initialization since this infrastrucutre is 
used for all future terraform.

```bash
terraform init

terraform apply
```