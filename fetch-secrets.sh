#!/bin/bash

set -e

SECRETS_DIR="./secrets"
mkdir -p "$SECRETS_DIR"

declare -A secrets_map=(
  ["MYSQL_ROOT_PASSWORD"]="myapp/mysql_root_password"
  ["MYSQL_USER"]="myapp/mysql_user"
  ["MYSQL_PASSWORD"]="myapp/mysql_password"
  ["MYSQL_DATABASE"]="myapp/mysql_database"
  ["PMA_USER"]="myapp/phpmyadmin_user"
  ["PMA_PASSWORD"]="myapp/phpmyadmin_password"
)

echo "🔐 Fetching AWS secrets..."
for key in "${!secrets_map[@]}"; do
  value=$(aws --profile stackcouture-user secretsmanager get-secret-value \
    --secret-id "${secrets_map[$key]}" \
    --query SecretString \
    --output text)

  echo -n "$value" > "$SECRETS_DIR/${key}.txt"
done

chmod 600 "$SECRETS_DIR"/*.txt
echo "✅ All secrets stored securely in ./secrets/"
