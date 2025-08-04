#!/bin/bash

if [ -z "$AWS_REGION" ]; then
    echo "Error: AWS_REGION is not set."
    exit 1
fi

if [ -z "$AWS_SECRET_NAME" ]; then
    echo "Error: AWS_SECRET_NAME is not set."
    exit 1
fi

SECRET_JSON=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $AWS_SECRET_NAME --query 'SecretString' --output text)

MYSQL_USER=$(echo $SECRET_JSON | jq -r '.MYSQL_USER')
MYSQL_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_PASSWORD')
MYSQL_ROOT_PASSWORD=$(echo $SECRET_JSON | jq -r '.MYSQL_ROOT_PASSWORD')
MYSQL_DATABASE=$(echo $SECRET_JSON | jq -r '.MYSQL_DATABASE')

if [ ! -f .env ]; then
    touch .env
fi

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

add_env_var "APP_NAME" "php-app"
add_env_var "AWS_SECRET_NAME" "myapp/db_app_credes"
add_env_var "APP_PORT" "8080"
add_env_var "AWS_REGION" "ap-south-1"

echo "Secrets fetched and environment variables added (if not already present) to .env!"
