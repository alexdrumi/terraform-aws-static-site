#generate keypair if not present
key-gen:
	@if [ ! -f MyKeyPair.pem ]; then \
		echo "Generating SSH key pair..."; \
		ssh-keygen -t rsa -b 4096 -f MyKeyPair.pem -N ""; \
	else \
		echo "MyKeyPair.pem already exists. Skipping generation."; \
	fi

# # export_env:
# # 	@set -a; source .env; set +a



# #https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs/45971167#45971167
# #. .env runs in the same shell as terraform
# init:
# 	. .env && terraform init

  
# #autoapprove gets rid of the enter prompt when running apply; better for CI/CD
# apply:
# 	. .env && terraform apply -auto-approve


# destroy:
# 	. .env && terraform destroy -auto-approve


ENV_SETUP = set -a && . .env && set +a &&

init:
	$(ENV_SETUP) terraform init

apply:
	$(ENV_SETUP) terraform apply -auto-approve

destroy:
	$(ENV_SETUP) terraform destroy -auto-approve
