# Initialization

Steps needed to initialize AWS infrastructure.

## Manual Steps

https://www.laptopmag.com/articles/use-bash-shell-windows-10

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

## Kubernetes Configuration

```bash
export ORGANIZATION=family-seams
export ENVIRONMENT=production
export CLUSTER_NAME=$ORGANIZATION-$ENVIRONMENT

# Example command to configure using default region
aws eks update-kubeconfig \
  --name $CLUSTER_NAME \
  --alias $CLUSTER_NAME-$AWS_DEFAULT_REGION

kubectl config set-context $CLUSTER_NAME-$AWS_DEFAULT_REGION

# Example command to configure any AWS Region
aws eks update-kubeconfig \
  --name $CLUSTER_NAME \
  --region $REGION \
  --alias $CLUSTER_NAME-$REGION

kubectl config set-context $CLUSTER_NAME-$REGION
```

## Terraform Steps

No workspaces are needed for initialization since this infrastrucutre is 
used for all future terraform.

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