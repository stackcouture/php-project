#!/bin/bash

# Set AWS region and secret name (defaults to ap-south-1 and myapp/db_app_credes if not provided)
AWS_REGION=ap-south-1
AWS_SECRET_NAME=myapp/db_app_credes

# Fetch the secret from AWS Secrets Manager (returns the secret as a JSON string)
SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $AWS_SECRET_NAME --query 'SecretString' --output text)

# Parse the secrets (assuming the secret is a JSON string)
MYSQL_USER=$(echo $SECRET_JSON | jq -r '.MYSQL_USER')
MYSQL_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_PASSWORD')
MYSQL_ROOT_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_ROOT_PASSWORD')
MYSQL_DATABASE=$(echo $SECRET_JSON | jq -r '.MYSQL_DATABASE')

# Check if the .env file exists, if not create it
if [ ! -f .env ]; then
    touch .env
fi

# Function to add a new variable only if it doesn't already exist in the .env file
add_env_var() {
    local var_name=$1
    local var_value=$2

    # Check if the variable already exists in the .env file
    if ! grep -q "^$var_name=" .env; then
        # If it doesn't exist, append the variable and its value to the .env file
        echo "$var_name=$var_value" >> .env
    else
        echo "$var_name already exists in .env, skipping..."
    fi
}

# Add the variables to the .env file (only if they don't already exist)
add_env_var "MYSQL_USER" "$MYSQL_USER"
add_env_var "MYSQL_PASSWORD" "$MYSQL_PASSWORD"
add_env_var "MYSQL_ROOT_PASSWORD" "$MYSQL_ROOT_PASSWORD"
add_env_var "MYSQL_DATABASE" "$MYSQL_DATABASE"

echo "APP_NAME=php-app" > .env
echo "AWS_SECRET_NAME=myapp/db_app_credes" > .env 
echo "APP_PORT=8080" > .env 

echo "Secrets fetched and environment variables added (if not already present) to .env!"
