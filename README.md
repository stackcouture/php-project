# PHP Project with Docker and AWS Secrets Manager

This project demonstrates how to build and deploy a PHP application using Docker, Docker Compose, and AWS Secrets Manager for securely managing sensitive information like database credentials.

---

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setting Up the Project](#setting-up-the-project)
- [Environment Configuration](#environment-configuration)
- [Running the Application](#running-the-application)
- [Accessing Secrets from AWS](#accessing-secrets-from-aws)
- [Docker Compose Configuration](#docker-compose-configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction

This is a demo project to showcase best practices for securely accessing secrets in a containerized PHP application. It uses:
- **Docker** for containerization
- **Docker Compose** for multi-container orchestration
- **AWS Secrets Manager** for secure credentials management

---

## Prerequisites

- Docker & Docker Compose installed
- AWS CLI configured with access to Secrets Manager
- PHP & Composer (optional for local development)
- An existing secret in AWS Secrets Manager

---

## Setting Up the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/php-docker-aws-secrets.git
   cd php-docker-aws-secrets

---

## Environment Configuration

This project uses `.env` files to store environment-specific variables securely. These include configuration for the application and sensitive database credentials.


```bash

1. Create a Secret in AWS Secrets Manager

Before starting the project, create a secret in AWS Secrets Manager containing your database credentials.

Use the following AWS CLI command:

aws secretsmanager create-secret \
  --name myapp/db_app_credes \
  --secret-string '{
    "DB_HOST": "db",
    "MYSQL_DATABASE": "db_shop",
    "MYSQL_USER": "appuser",
    "MYSQL_PASSWORD": "appuser",
    "MYSQL_ROOT_PASSWORD": "rootpass",
    "PMA_USER": "root",
    "PMA_PASSWORD": "rootpass"
}'

🔐 Make sure your AWS CLI is configured and the IAM user/role has secretsmanager:CreateSecret and secretsmanager:GetSecretValue permissions.

2. Create the .env File
In the root directory of the project, create a .env file:

APP_NAME=my_php_app
APP_PORT=8080
AWS_REGION=us-east-1
AWS_SECRET_NAME=myapp/db_app_credes
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
MYSQL_ROOT_PASSWORD=secretpassword
MYSQL_DATABASE=mydatabase

📝 This file contains placeholder values and will be updated with actual credentials fetched from AWS Secrets Manager.

3. Fetch Secrets with fetch_secrets.sh
Run the following command to fetch your credentials from AWS Secrets Manager and update the .env file automatically:

AWS_REGION="us-east-1" AWS_SECRET_NAME="myapp/db_app_credes" bash fetch_secrets.sh
✅ What This Script Does
Retrieves the secret from AWS Secrets Manager using the specified region and secret name.

Parses the JSON output of the secret.

Inserts the credentials (e.g., MYSQL_USER, MYSQL_PASSWORD, etc.) into the .env file.

Leaves existing non-secret values (like APP_NAME, APP_PORT) untouched.

🔐 Best Practices
Always add .env to your .gitignore file:

echo ".env" >> .gitignore
Do not commit sensitive values to version control.

Use least-privilege IAM roles or users when accessing Secrets Manager.


Let me know if you'd like me to include an example of the `fetch_secrets.sh` script in the README or as a separate file reference.

```

---

## Running the Application

This project uses `.env` files to store environment-specific variables securely. These include configuration for the application and sensitive database credentials.


```bash
1. Build Docker Images:
To build the Docker images for the PHP application, MySQL, and phpMyAdmin, run:


docker-compose build
2. Start the Containers:
To start the application, use Docker Compose:


docker-compose up -d
This will start the application in the background.

3. Access the Application:
After the containers are up, you can access:

PHP Application: http://localhost:8080

phpMyAdmin: http://localhost:8081
```
---

## Accessing Secrets from AWS

Using AWS SDK for PHP

Install AWS SDK for PHP (if not already done by Composer):

Run the following to install the AWS SDK:

```bash
composer require aws/aws-sdk-php
```

Fetching Secrets:

In your PHP application, use the AWS SDK to fetch the secrets for database access. Example:

```bash
$secretValue = $client->getSecretValue(['SecretId' => $secretName]);
```

The secrets will be injected into your application dynamically, ensuring your credentials are never hard-coded.

---

