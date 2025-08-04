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

## environment-configuration

This project uses a `.env` file to store environment-specific variables securely. These variables include application settings, database credentials, and AWS Secrets Manager configuration.

### 1. Create the `.env` File

In the root directory of the project, create a `.env` file and define the following environment variables:

```env
APP_NAME=my_php_app
APP_PORT=8080
AWS_REGION=us-east-1
AWS_SECRET_NAME=myapp/db_creds
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
MYSQL_ROOT_PASSWORD=secretpassword
MYSQL_DATABASE=mydatabase

💡 Tip: Do not commit your .env file to version control. Make sure it is listed in your .gitignore.