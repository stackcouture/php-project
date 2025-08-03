<?php
// define('DB_HOST', getenv('DB_HOST') ?: 'db');
// define('DB_NAME', getenv('DB_NAME') ?: 'db_shop');
// define('DB_USER', getenv('DB_USER') ?: 'root');
// define('DB_PASS', getenv('DB_PASS') ?: 'rootpass');

function get_env_secret($key, $default = null) {
    $file = getenv("${key}_FILE");
    if ($file && file_exists($file)) {
        return trim(file_get_contents($file));
    }
    return getenv($key) ?: $default;
}

define('DB_HOST', getenv('DB_HOST') ?: 'db');
define('DB_NAME', get_env_secret('DB_NAME', 'default_db'));
define('DB_USER', get_env_secret('DB_USER', 'default_user'));
define('DB_PASS', get_env_secret('DB_PASS', 'default_pass'));

?>
