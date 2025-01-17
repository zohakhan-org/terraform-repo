#!/bin/bash
echo "Running Terraform Plan and deploy..."
pwd
ls -lrt
echo "services configuration "
cat services-config.yaml
echo "services to be deployed "
cat services_to_deploy.yaml
echo "terraform.tfvars file"
cat terraform.tfvars

SERVICES_FILE="services_to_deploy.yaml"
# Path to the services configuration file or tfvars file
TFVARS_FILE="terraform.tfvars"


# Path to the root module or module directories
MODULES_DIR="modules"

if [[ ! -f "$SERVICES_FILE" ]]; then
  echo "Error: $SERVICES_FILE not found!"
  exit 1
fi

# Read the services to deploy from the YAML file using yq
SELECTED_SERVICES=$(yq -r '.services[]' "$SERVICES_FILE")
ORIGINAL_DIR=$(pwd)

# Iterate over the selected services and call the corresponding modules
for SERVICE in $SELECTED_SERVICES; do

    MODULE_PATH="$MODULES_DIR/$SERVICE"

    # Ensure the module directory exists
    if [[ ! -d "$MODULE_PATH" ]]; then
      echo "Error: Module directory $MODULE_PATH not found!"
      exit 1
    fi

    case "$SERVICE" in
    "ecs")
      echo "Deploying ECS service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      export TF_LOG=DEBUG
      ls -lrt
      cat "$TFVARS_FILE"
      terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=modules.ecs
      echo "Terraform apply"

      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE"  -target=modules.ecs
      cd "$ORIGINAL_DIR" || exit
      ;;
    "iam")
      echo "Deploying IAM service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"
      cat "$TFVARS_FILE" && terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=modules.iam
      echo "Terraform apply"
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=modules.iam
      cd "$ORIGINAL_DIR" || exit
      ;;
    "s3")
      echo "Deploying S3 service..."
      chmod +r terraform.tfvars
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt
      terraform  -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE" -target=modules.s3
      echo "Terraform apply"
      terraform  -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=modules.s3
      cd "$ORIGINAL_DIR" || exit
      ;;
    "iam_user_creation")
      echo "Deploying IAM User Creation service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"

      terraform -chdir="$MODULE_PATH" plan -refresh-only  -var-file="$TFVARS_FILE"  -target=modules.iam_user_creation
      echo "Terraform apply"

      terraform -chdir="$MODULE_PATH" apply  -var-file="$TFVARS_FILE" -target=modules.iam_user_creation
      cd "$ORIGINAL_DIR" || exit
      ;;
    "ec2")
      echo "Deploying EC2 service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"
      terraform -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE"
      echo "Terraform apply"
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" --auto-approve
      ls -lrt ./modules/ec2
      cat ./modules/ec2/private_ips.txt
      cd "$ORIGINAL_DIR" || exit
      ;;
    "vpc_nat_ec2")
      echo "Deploying VPC NAT EC2 service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"
      terraform -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE"
      echo "Terraform apply"
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" --auto-approve
      ls -lrt ./modules/vpc_nat_ec2
      cd "$ORIGINAL_DIR" || exit
      ;;
    "eks")
      echo "Deploying EKS service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"
      ls -a
      terraform -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE"
      echo "Terraform apply"
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" --auto-approve
      ls -lrt ./modules/eks
      cd "$ORIGINAL_DIR" || exit
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;

  esac

done


