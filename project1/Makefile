# TF_COMMAND = terraform
# TF_OPTIONS = -var-file=config.tfvars

init:
	terraform init

# plan:
# 	$(TF_COMMAND) plan $(TF_OPTIONS)

a:
	terraform apply --auto-approve

d:
	terraform destroy --auto-approve

# .PHONY: init plan apply destroy
