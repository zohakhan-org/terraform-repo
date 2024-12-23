#!/bin/bash

# Inputs
SERVICES=$1
CONFIG_FILE="../services-config.yaml"
TFVARS_FILE="terraform.tfvars"

if [[ -z "$SERVICES" ]]; then
  echo "Error: No Services provided <comma-sepetated-services?"
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file $CONFIG_FILE not found!"
  exit 1
fi

echo "Selected Services: $SERVICES"

# Remove existing terraform.tfvars if it exists
if [[ -f "$TFVARS_FILE" ]]; then
  rm "$TFVARS_FILE"
  echo "Deleted existing $TFVARS_FILE"
fi

# Extract region from the config file
#REGION=$(grep '^region:' "$CONFIG_FILE" | awk -F': ' '{print $2}' | tr -d '\"')
AWS_REGION=$(yq -r '.aws_region' "$CONFIG_FILE")
if [[ -z "$AWS_REGION" ]]; then
  echo "Error: Region is not defined in the configuration file."
  exit 1
fi
echo "aws_region = \"$AWS_REGION\"" >> "$TFVARS_FILE"

# Parse YAML and filter selected services
python3 - <<EOF
import yaml
import sys

config_file = "$CONFIG_FILE"
tfvars_file = "$TFVARS_FILE"

#Parse the services argument (comma-separated)

selected_services = "${SERVICES}".split(',')

try:
  with open(config_file, 'r') as file:
      config = yaml.safe_load(file)

except FileNotFoundError:
  print(f"Error: Configuration file {config_file} not found.")
  sys.exit(1)

# Write the terraform variables file
try:
  with open(tfvars_file, 'a') as tfvars:
    for service, settings in config.get('services', {}).items():
        enabled = service in selected_services
        tfvars.write(f"enable_{service} = {str(enabled).lower()}\n")
        if enabled:
            for key, value in settings.items():
              #Escape special characters in string
              if isinstance(value, str):
                value=value.replace('"', '\\"')
              tfvars.write(f"{service}_{key} = \"{value}\"\n")

  print(f"Generated Terraform variables file: {tfvars_file}")

except Exception as e:
  print(f"Error writing Terraform variables: {str(e)}")
  sys.exit(1)
EOF

cat "$TFVARS_FILE"