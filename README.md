# Terraform AWS project

<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<br />
<div align="center">
  <a href="https://github.com/alexdrumi/terraform-aws-static-site">
    <img src="assets/aws_terraform.jpg" alt="aws_terraform.jpg" width="550" height="300">
  </a>
</div>

<div align="left">

## Prerequisites

This Terraform project is designed to host a static site using a scalable, highly available architecture built with EC2, ELB, Auto Scaling, CloudFront, NAT Gateways, Application Load Balancers, and Routing Tables. Unlike the usual S3 + CloudFront setup, this solution offers advanced control over networking, security, and routing, making it ideal for both learning and production-grade deployments.

1. **IAM User and Policy:**  
   - Create an IAM user in your AWS account and attach the provided IAM policy (see `iam_policy.json`).
     
   - This policy grants permissions for S3, EC2, ELB, Auto Scaling, CloudFront, and CloudWatch operations required by the Terraform configuration.
     
   - **Note:** The policy is intentionally broad to ensure all Terraform actions work smoothly. In a production environment, consider restricting permissions to only those necessary.


2. **Environment Variables:**  
   - Copy `.env.example` to `.env` and fill in your AWS credentials along with any required Terraform variables.  
   - The `.env` file has to include variables like:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `AWS_DEFAULT_REGION`
     - Terraform variables prefixed with `TF_VAR_` (for example, `TF_VAR_key_name="MyKeyPair"`).  

   - **Important:** DO NOT COMMIT THE '.env' file to your repository. Add it to your '. gitignore'.


4. **SSH Key Pair Generation:**  
   - **Automatic Generation:** The provided Makefile includes a `key-gen` target that automatically generates an SSH key pair. This will generate two files in the project root:
     - `MyKeyPair.pem` (the private key)
     - `MyKeyPair.pem.pub` (the public key)
       
   - **Security:** Ensure that the private key file has strict permissions (e.g., run `chmod 400 MyKeyPair.pem`).
   - **Important:** DO NOT COMMIT THE 'MyKeyPair.pem' and MyKeyPair.pem.pub' file to your repository. Add it to your '. gitignore'.

   - [AWS Key Pair Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)


5. **Initialize the SSH Key Pair:**  
   Run the following command to generate the key pair (if not already present):
   ```bash
   make key-gen

6. **Terraform setup:**
   ```bash
   make init
   make apply

7. **Example folder structure after running points 4&5:**
   ```bash
   ├── Makefile
   ├── MyKeyPair.pem
   ├── MyKeyPair.pem.pub
   ├── README.md
   ├── example_iam_policy.json
   ├── main.tf
   ├── modules
   ├── outputs.tf
   ├── setup.sh
   └── variables.tf

</div>

