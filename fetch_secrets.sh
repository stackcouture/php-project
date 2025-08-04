#!/bin/bash

AWS_REGION=ap-south-1
AWS_SECRET_NAME=myapp/db_app_credes

SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $AWS_SECRET_NAME --query 'SecretString' --output text)

MYSQL_USER=$(echo $SECRET_JSON | jq -r '.MYSQL_USER')
MYSQL_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_PASSWORD')
MYSQL_ROOT_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_ROOT_PASSWORD')
MYSQL_DATABASE=$(echo $SECRET_JSON | jq -r '.MYSQL_DATABASE')

if [ ! -f .env ]; then
    touch .env
fi

# Function to add a new variable only if it doesn't already exist in the .env file
add_env_var() {
    local var_name=$1
    local var_value=$2

    if ! grep -q "^$var_name=" .env; then
        echo "$var_name=$var_value" >> .env
    else
        echo "$var_name already exists in .env, skipping..."
    fi
}

add_env_var "MYSQL_USER" "$MYSQL_USER"
add_env_var "MYSQL_PASSWORD" "$MYSQL_PASSWORD"
add_env_var "MYSQL_ROOT_PASSWORD" "$MYSQL_ROOT_PASSWORD"
add_env_var "MYSQL_DATABASE" "$MYSQL_DATABASE"

echo "APP_NAME=php-app" >> .env
echo "AWS_SECRET_NAME=myapp/db_app_credes" >> .env
echo "APP_PORT=8080" >> .env

echo "Secrets fetched and environment variables added (if not already present) to .env!"
