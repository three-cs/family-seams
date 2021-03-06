# Environment

Resources that are unique to a single environment.

And environment is a separation between the full application stack.

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

**IMPORTANT** Be sure to verify the correct workspace before execcuting the terraform.

```bash
terraform init

# Change workspace
terraform workspace select {ENVIRONMENT}

terraform apply
```

### Terraform workspace
Workspaces are used to separate resources that are managed between environments.
The workspace name becomes the environment identifier.

```bash
# Show available workspaces.
terraform workspace list

# Switch workspaces
terraform workspace select {ENVIRONMENT}

# Create new workspace
terraform workspace new {ENVIRONMENT}
```