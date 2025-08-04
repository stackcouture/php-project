#!/bin/bash

set -e

# Path to the .env file that will be generated
ENV_FILE=".env"

# Secret name in AWS Secrets Manager
SECRET_NAME="myapp/db_app_credes"

echo "Fetching AWS secret for $SECRET_NAME..."
secret_json=$(aws --profile stackcouture-user secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --query SecretString \
  --output text)

# Parse the JSON and extract individual secrets
DB_HOST=$(echo "$secret_json" | jq -r '.DB_HOST')
MYSQL_DATABASE=$(echo "$secret_json" | jq -r '.MYSQL_DATABASE')
MYSQL_USER=$(echo "$secret_json" | jq -r '.MYSQL_USER')
MYSQL_PASSWORD=$(echo "$secret_json" | jq -r '.MYSQL_PASSWORD')

# Function to replace or append key-value pair in .env file
replace_or_append() {
  local key=$1
  local value=$2

  # Check if the key already exists in the .env file
  if grep -q "^$key=" "$ENV_FILE"; then
    # Replace the existing value
    sed -i "s/^$key=.*/$key=$value/" "$ENV_FILE"
  else
    # Append the key-value pair
    echo "$key=$value" >> "$ENV_FILE"
  fi
}

# Ensure the secrets are correctly added or replaced
echo "Updating .env file with new secrets..."

replace_or_append "DB_HOST" "$DB_HOST"
replace_or_append "MYSQL_DATABASE" "$MYSQL_DATABASE"
replace_or_append "MYSQL_USER" "$MYSQL_USER"
replace_or_append "MYSQL_PASSWORD" "$MYSQL_PASSWORD"

# Set proper permissions for the .env file
chmod 600 "$ENV_FILE"

echo "✅ Secrets updated in the .env file"
