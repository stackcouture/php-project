<?php
require_once '/var/www/html/vendor/autoload.php';

use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;

function fetchSecrets($region, $secretName) {
    $client = new SecretsManagerClient([
        'version' => 'latest',
        'region' => $region,
    ]);

    try {
        $result = $client->getSecretValue(['SecretId' => $secretName]);
        if (!isset($result['SecretString'])) {
            throw new Exception("SecretString missing in AWS response");
        }
        return json_decode($result['SecretString'], true);
    } catch (AwsException $e) {
        die("AWS Secrets Manager Error: " . $e->getAwsErrorMessage());
    } catch (Exception $e) {
        die("Secret fetch failed: " . $e->getMessage());
    }
}

$region = getenv('AWS_REGION') ?: 'ap-south-1';
$secretName = getenv('AWS_SECRET_NAME') ?: 'myapp/db_my_creds';

$secrets = fetchSecrets($region, $secretName);

define('DB_HOST', getenv('DB_HOST') ?: 'db');
define('DB_NAME', $secrets['MYSQL_DATABASE'] ?? 'default_db');
define('DB_USER', $secrets['MYSQL_USER'] ?? 'default_user');
define('DB_PASS', $secrets['MYSQL_PASSWORD'] ?? 'default_pass');
