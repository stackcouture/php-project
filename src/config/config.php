<?php
require 'vendor/autoload.php';

use Aws\SecretsManager\SecretsManagerClient;
use Aws\Exception\AwsException;

function fetchSecrets($region, $secretName) {
    $client = new SecretsManagerClient([
        'version' => 'latest',
        'region' => $region,
    ]);

    try {
        $result = $client->getSecretValue(['SecretId' => $secretName]);
        $secretString = $result['SecretString'];
        return json_decode($secretString, true);
    } catch (AwsException $e) {
        die("Error fetching secrets: " . $e->getMessage());
    }
}

$region = getenv('AWS_REGION') ?: 'us-east-1';
$secretName = getenv('AWS_SECRET_NAME') ?: 'myapp/db_creds';

$secrets = fetchSecrets($region, $secretName);

define('DB_HOST', getenv('DB_HOST') ?: 'db');
define('DB_NAME', $secrets['MYSQL_DATABASE']);
define('DB_USER', $secrets['MYSQL_USER']);
define('DB_PASS', $secrets['MYSQL_PASSWORD']);

?>
