# Generate SSH key pair if not present
key-gen:
	@if [ ! -f MyKeyPair.pem ]; then \
		echo "Generating SSH key pair..."; \
		ssh-keygen -t rsa -b 4096 -f MyKeyPair.pem -N ""; \
	else \
		echo "MyKeyPair.pem already exists. Skipping generation."; \
	fi

export_env:
	@set -a; source .env; set +a



#https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs/45971167#45971167
init:
	@set -a; source .env; set +a; terraform init

  
#autoapprove gets rid of the enter prompt when running apply; better for CI/CD
apply:
	@set -a; source .env; set +a; terraform apply -auto-approve


destroy:
	@set -a; source .env; set +a; terraform destroy -auto-approve
