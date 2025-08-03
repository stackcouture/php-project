<?php
include_once 'init.php';

$cmrId = Session::get("cmrId");
if ($cmrId) {
    $ct->delCustomerCart();
    $pd->delCompareData($cmrId);
}

Session::destroy();
header("Location: login.php");
exit();
