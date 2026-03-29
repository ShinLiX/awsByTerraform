
# aws-cs5700

Terraform project to provision a minimal AWS EC2 environment for CS5700 coursework.

## Overview

This setup creates:

- An EC2 instance (Ubuntu 22.04 LTS, x86_64)
- A minimal VPC with public subnet
- Internet access (Internet Gateway + Route Table)
- A security group allowing SSH from your IP only
- Docker and basic tools pre-installed via `user_data`

## Default Configuration

```hcl
aws_region           = "us-east-1"
project_name         = "cs5700"
instance_type        = "t3.small"
root_volume_size     = 30
public_key_path      = "~/.ssh/aws_general.pub"
ssh_private_key_path = "~/.ssh/aws_general"
````

## Required Manual Step

You **must** set your public IP in `terraform.tfvars`.

1. Copy the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Get your public IP:

```bash
curl ifconfig.me
```

3. Update `terraform.tfvars`:

```hcl
my_ip_cidr = "YOUR_IP/32"
```

Example:

```hcl
my_ip_cidr = "12.34.56.78/32"
```

## Usage

### Initialize

```bash
terraform init
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

Type `yes` to confirm.

## Outputs

After apply, Terraform will output:

* Public IP
* Public DNS
* SSH command
* SSH tunnel command (for port 8080)

## Connect via SSH

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<public_ip>
```

## Upload Project Files

Example:

```bash
scp -i ~/.ssh/id_rsa -r ~/Downloads/Labsetup ubuntu@<public_ip>:~
```

## Installed Packages

* docker.io
* docker-compose
* curl
* git
* unzip
* net-tools
* ca-certificates

## Stop vs Destroy

* **Stop instance** (AWS Console): saves compute cost
* **Destroy resources**:

```bash
terraform destroy
```

## Notes

* Only port 22 is open (SSH)
* Port 8080 is accessed via SSH tunnel only
* Update `my_ip_cidr` if your network changes

## Troubleshooting: Invalid AWS Credentials

If you see an error like:

```

InvalidClientTokenId: The security token included in the request is invalid

````

It means your AWS credentials are invalid, expired, or misconfigured.

### Fix: Create a New Access Key

1. Go to AWS Console
2. Click your account (top-right)
3. Go to **Security credentials**
4. Find **Access keys**
5. Click **Create access key**
6. Save:
   - `AWS Access Key ID`
   - `AWS Secret Access Key`

### Reconfigure Locally

```bash
aws configure
````

Enter:

* Access Key ID
* Secret Access Key
* Region: `us-east-1`
* Output: `json`

### Verify

```bash
aws sts get-caller-identity
````

If successful, you will see your account info in JSON format.

### Then Retry

```bash
terraform plan
```

If it works, your credentials are correctly configured.

## Troubleshooting: SSH Key Issues (Permission Denied)

If you see:

```

Permission denied (publickey)

````

It usually means the SSH key on your local machine does not match the public key configured in EC2.

### Fix Option: Generate a New SSH Key

If you don’t have a working key (or forgot the passphrase), create a new one:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/aws_general -C "aws-general"
````

Press Enter twice to skip passphrase (recommended for simplicity).

This creates:

* Private key: `~/.ssh/aws_general`
* Public key: `~/.ssh/aws_general.pub`

### Update Terraform Variables

Edit `terraform.tfvars`:

```hcl
public_key_path      = "~/.ssh/aws_general.pub"
ssh_private_key_path = "~/.ssh/aws_general"
```

### Recreate the EC2 Instance

SSH keys are injected only at instance creation time, so you must recreate the instance:

```bash
terraform apply -replace=aws_instance.this
```

### Connect with New Key

After apply finishes:

```bash
ssh -i ~/.ssh/aws_general ubuntu@<public_ip>
```

### Notes

* Changing the key pair does NOT update existing EC2 instances
* You must recreate the instance to apply a new key
* Public IP may change after recreation


##