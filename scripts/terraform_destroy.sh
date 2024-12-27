#!/bin/bash
echo "Running Terraform Plan and Destroy..."
pwd
ls -lrt
echo "services configuration "
cat services-config.yaml
echo "services to be destroyed "
cat services_to_deploy.yaml
echo "terraform.tfvars file"
cat terraform.tfvars

SERVICES_FILE="services_to_deploy.yaml"
TFVARS_FILE="terraform.tfvars"
MODULES_DIR="modules"

if [[ ! -f "$SERVICES_FILE" ]]; then
  echo "Error: $SERVICES_FILE not found!"
  exit 1
fi

# Read the services to destroy from the YAML file using yq
SELECTED_SERVICES=$(yq -r '.services[]' "$SERVICES_FILE")
ORIGINAL_DIR=$(pwd)

# Iterate over the selected services and destroy the corresponding modules
for SERVICE in $SELECTED_SERVICES; do

    MODULE_PATH="$MODULES_DIR/$SERVICE"

    # Ensure the module directory exists
    if [[ ! -d "$MODULE_PATH" ]]; then
      echo "Error: Module directory $MODULE_PATH not found!"
      exit 1
    fi

    case "$SERVICE" in
    "ecs")
      echo "Destroying ECS service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE" -target=modules.ecs
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" -target=modules.ecs --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    "iam")
      echo "Destroying IAM service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE" -target=modules.iam
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" -target=modules.iam --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    "s3")
      echo "Destroying S3 service..."
      chmod +r terraform.tfvars
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE" -target=modules.s3
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" -target=modules.s3 --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    "iam_user_creation")
      echo "Destroying IAM User Creation service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE" -target=modules.iam_user_creation
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" -target=modules.iam_user_creation --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    "ec2")
      echo "Destroying EC2 service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE"
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    "vpc_nat_ec2")
      echo "Destroying VPC with NAT Gateway and EC2 service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "Terraform plan (destroy)"
      terraform -chdir="$MODULE_PATH" plan -destroy -var-file="$TFVARS_FILE"
      echo "Terraform destroy"
      terraform -chdir="$MODULE_PATH" destroy -var-file="$TFVARS_FILE" --auto-approve
      cd "$ORIGINAL_DIR" || exit
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac

done
