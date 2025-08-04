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
$secretName = getenv('AWS_SECRET_NAME') ?: 'myapp/db_app_credes';

$secrets = fetchSecrets($region, $secretName);

putenv("MYSQL_USER=" . $secrets['MYSQL_USER']);
putenv("MYSQL_PASSWORD=" . $secrets['MYSQL_PASSWORD']);
putenv("MYSQL_ROOT_PASSWORD=" . $secrets['MYSQL_ROOT_PASSWORD']);
putenv("MYSQL_DATABASE=" . $secrets['MYSQL_DATABASE']);
