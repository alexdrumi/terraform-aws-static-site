export_env: 
	@export $(grep -v '^#' .env | xargs)
  
init: export_env
	terraform init
  
# autoapprove gets rid of the enter option prompt when running apply, better for CI/CD also later
apply: export_env
	terraform apply -auto-approve 