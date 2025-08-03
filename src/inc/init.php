<?php
// Use require_once/include_once to avoid multiple inclusions
include_once 'lib/Session.php';
Session::init();

include_once 'lib/Database.php';
include_once 'helpers/Formate.php';

spl_autoload_register(function($class){
    include_once "classess/" . $class . ".php";
});

$db = new Database();
$fm = new Format();
$pd = new Product();
$cat = new Category();
$ct = new Cart();
$cmr = new Customer();

header("Cache-Control: no-cache, must-revalidate");
header("Pragma: no-cache"); 
header("Expires: Sat, 26 Jul 1997 05:00:00 GMT"); 
header("Cache-Control: max-age=2592000");
