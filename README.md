## Prerequisites
1. Create an IAM user in your AWS account and attach the provided IAM policy (see `iam_policy.json`).

2. Copy `.env.example` to `.env` and fill in your AWS credentials.
   
3. **SSH Key Pair:** Generate an SSH key pair if you don't have one. Name your private key `MyKeyPair.pem` and place it in the root directory of this project. Ensure that the file permissions are set to 400 (e.g., run `chmod 400 MyKeyPair.pem`). https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

4. Run the following commands to initialize and apply the Terraform configuration:
   ```bash
   terraform init
   terraform apply

5. Example Folder Structure
   '''bash
   ├── Makefile
   ├── MyKeyPair.pem
   ├── MyKeyPair.pem.pub
   ├── README.md
   ├── main.tf
   ├── modules
   ├── outputs.tf
   ├── setup.sh
   ├── terraform.tfstate
   ├── terraform.tfstate.backup
   └── variables.tf
