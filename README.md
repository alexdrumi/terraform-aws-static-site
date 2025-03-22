## Prerequisites
1. Create an IAM user in your AWS account and attach the provided IAM policy (see `iam_policy.json`).
2. Copy `.env.example` to `.env` and fill in your AWS credentials.
3. **SSH Key Pair:** Generate an SSH key pair if you don't have one. Name your private key `MyKeyPair.pem` and place it in the root directory of this project. Ensure that the file permissions are set to 400 (e.g., run `chmod 400 MyKeyPair.pem`).
4. Run the following commands to initialize and apply the Terraform configuration:
   ```bash
   terraform init
   terraform apply
