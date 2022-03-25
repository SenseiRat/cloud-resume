init:
	terraform init \
		-var="aws_access_key=${TF_VAR_aws_access_key}" \
		-var="aws_secret_key=${TF_VAR_aws_secret_key}" \
		-var="aws_region=${TF_VAR_aws_region}" \
		-var="backend_bucket=${TF_VAR_backend_bucket}"

plan:
	terraform plan

apply:
	terraform apply