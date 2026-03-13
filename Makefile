default: module.ci

# External Inputs...
CHECKOV_TAG ?= latest
TFLINT_TAG ?= latest
TRIVY_TAG ?= latest

MODULES ?= aws/iam-oidc-github-actions \
					 aws/iam-role-github-actions \
					 aws/eks-irsa

REPO_ROOT=$(shell pwd)

# Runs all CI-related steps for this Terraform module...
.PHONY: module.ci
module.ci: module.ci.prerequisites module.ci.lint


# Runs CI-related prerequisite tasks...
.PHONY: module.ci.prerequisites
module.ci.prerequisites:
	docker pull bridgecrew/checkov:${CHECKOV_TAG}
	docker pull ghcr.io/terraform-linters/tflint:${TFLINT_TAG}; \
	docker pull aquasec/trivy:${TRIVY_TAG};


# Displays various environment context details for troubleshooting purposes...
.PHONY: module.ci.env
module.ci.env:
	env
	terraform --version


# Runs all linter-related tasks for this Terraform module subdirectories...
.PHONY: module.ci.lint
module.ci.lint: module.lint.terraform module.lint.tflint module.lint.trivy module.lint.checkov


# Runs "terraform fmt" against project root...
# Runs "terraform validate" against $(MODULES) directory list...
.PHONY: module.lint.terraform
module.lint.terraform:
	terraform fmt -check -diff -recursive || exit $?; \
	for MODULE in $(MODULES); do \
		echo "\n\n\nRunning Terraform Validate against $${MODULE}...\n\n\n"; \
		cd $${MODULE}; \
		terraform init || exit $?; \
		terraform validate || exit $?; \
		cd ..; \
	done


# Runs terraform-linters/tflint against $(MODULES) directory list...
# This breaks at the first module with TFLint errors to kill the CI/CD workflow.
.PHONY: module.lint.tflint
module.lint.tflint:
	for MODULE in $(MODULES); do \
		echo "\n\n\nRunning TFLint against $${MODULE}...\n\n\n"; \
		cd $${MODULE}; \
		terraform init || exit $?; \
		docker run --rm -v "$(shell pwd):/src" -v tflint-cache:/root/.tflint.d/plugins \
			--entrypoint /bin/sh ghcr.io/terraform-linters/tflint:${TFLINT_TAG} \
			-c "tflint --init --config=/src/.cicd/.tflint.hcl; tflint --config=/src/.cicd/.tflint.hcl --chdir=/src/$${MODULE}" \
			|| exit $?; \
		cd ${REPO_ROOT}; \
	done


# Runs aquasec/trivy against $(MODULES) directory list...
# This breaks at the first module with trivy errors to kill the CI/CD workflow.
.PHONY: module.lint.trivy
module.lint.trivy:
	for MODULE in $(MODULES); do \
		echo "\n\n\nRunning Trivy FS Scan against $${MODULE}...\n\n\n"; \
		docker run --rm \
			-v "trivy-cache:/root/.cache/trivy" \
			-v "$(shell pwd):/src" \
			aquasec/trivy:${TRIVY_TAG} fs --config=./src/.cicd/trivy/config.yaml ./src/$${MODULE} \
		|| exit $?; \
		cd ${REPO_ROOT}; \
	done


# Runs bridgecrew/checkov against $(MODULES) directory list...
# This breaks at the first module with checkov errors to kill the CI/CD workflow.
.PHONY: module.lint.checkov
module.lint.checkov:
	echo "\n\n\nRunning Checkov against .github...\n\n\n"; \
	docker run --rm --tty --volume "$(shell pwd):/src" --workdir /src \
		bridgecrew/checkov:${CHECKOV_TAG} --config-file /src/.cicd/.checkov.yaml --directory /src/.github \
		|| exit $?; \
	for MODULE in $(MODULES); do \
		echo "\n\n\nRunning Checkov against $${MODULE}...\n\n\n"; \
		docker run --rm --tty --volume "$(shell pwd):/src" --workdir /src \
			bridgecrew/checkov:${CHECKOV_TAG} --config-file /src/.cicd/.checkov.yaml --directory $${MODULE} \
		|| exit $?; \
		cd ${REPO_ROOT}; \
	done
