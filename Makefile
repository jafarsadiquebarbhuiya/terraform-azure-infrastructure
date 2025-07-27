.PHONY: help plan apply destroy validate fmt clean

help:
	@echo "Available commands:"
	@echo "  make plan ENV=<env>     - Plan changes for environment"
	@echo "  make apply ENV=<env>    - Apply changes to environment"
	@echo "  make destroy ENV=<env>  - Destroy environment"
	@echo "  make validate           - Validate all Terraform files"
	@echo "  make fmt                - Format all Terraform files"
	@echo "  make clean              - Clean up temporary files"
	@echo ""
	@echo "Environments: dev, staging, prod"
	@echo ""
	@echo "Examples:"
	@echo "  make plan ENV=dev"
	@echo "  make apply ENV=staging"

validate:
	@echo "Validating Terraform configuration..."
	@for dir in environments/*/; do \
		echo "Validating $$dir"; \
		cd $$dir && terraform init -backend=false && terraform validate && cd ../..; \
	done
	@echo "✅ Validation complete!"

fmt:
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive .
	@echo "✅ Formatting complete!"

plan:
	@if [ -z "$(ENV)" ]; then echo "❌ Usage: make plan ENV=<environment>"; exit 1; fi
	@./scripts/deploy.sh $(ENV) plan

apply:
	@if [ -z "$(ENV)" ]; then echo "❌ Usage: make apply ENV=<environment>"; exit 1; fi
	@./scripts/deploy.sh $(ENV) apply

destroy:
	@if [ -z "$(ENV)" ]; then echo "❌ Usage: make destroy ENV=<environment>"; exit 1; fi
	@./scripts/deploy.sh $(ENV) destroy

clean:
	@echo "Cleaning up temporary files..."
	@find . -name "*.tfplan" -delete
	@find . -name ".terraform" -type d -exec rm -rf {} +
	@find . -name ".terraform.lock.hcl" -delete
	@echo "✅ Cleanup complete!"
