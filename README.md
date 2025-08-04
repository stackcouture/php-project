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

## Docker Compose Configuration

The docker-compose.yml file defines the services required for the application:

Web Service (PHP): The PHP app running with Apache and Docker.

MySQL Database: A MySQL container used to store application data.

phpMyAdmin: A web-based interface to manage the MySQL database.

Sample Docker Compose

```bash
version: '3'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${APP_NAME}
    ports:
      - "${APP_PORT}:8080"
    depends_on:
      - db
    environment:
      DB_HOST: db
      AWS_REGION: ${AWS_REGION}
      AWS_SECRET_NAME: ${AWS_SECRET_NAME}
    restart: unless-stopped

  db:
    image: mysql:5.7
    container_name: mysql-db-prod
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - app-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:5.1.0
    container_name: phpmyadmin
    restart: always
    depends_on:
      - db
    ports:
      - "8081:80"
    environment:
      PMA_HOST: db
      PMA_USER: ${MYSQL_USER}
      PMA_PASSWORD: ${MYSQL_PASSWORD}
    networks:
      - app-network

volumes:
  db_data:

networks:
  app-network:
    driver: bridge
```

---

## Troubleshooting

If you encounter any issues, consider the following steps:

Check Docker Logs: Run docker-compose logs to view logs from all containers.

Ensure AWS Credentials: Make sure your AWS credentials (like AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY) are correctly configured.

Verify Environment Variables: Double-check that your .env file is properly configured with all required variables.

---

## 🤝 Contributing

We welcome contributions to improve this project! Please follow the steps below to contribute:

1. Fork the repository
    Click the Fork button at the top right of the repository page to create your own copy.

2. Clone your fork

    git clone https://github.com/your-username/repository-name.git
    cd repository-name

3. Create a new feature branch
    git checkout -b feature/my-feature

4. Make your changes
    Add your code, documentation, or improvements.

5. Commit your changes

    git commit -m "Add new feature"

6. Push to your forked repository

    git push origin feature/my-feature

7. Open a Pull Request
    Go to the original repository and click Compare & pull request.
    Clearly describe what your changes do and why they are needed.
