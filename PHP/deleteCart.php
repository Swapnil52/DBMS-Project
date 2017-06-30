<?php

$number = "";
$region = "";

if (isset($_GET["number"]))
{

	$number = $_GET["number"];

}

if (isset($_GET["region"]))
{

	$region = $_GET["region"];

}

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('');

mysqli_query($db, "start transaction;");

$flag = 1;

$query = "delete from cart where Phone = '$number' and O_name = '$region';";
$flag = mysqli_query($db, $query) or die('Query error');

if ($flag)
{

	mysqli_query($db, "commit;") or die('Commit error');
	$r = array("Success" => 1);
	echo json_encode($r);

}
else 
{

	mysqli_query($db, "rollback;") or die('rollback error');
	$r = array("Success" => 0);
	echo json_encode($r);

}

mysqli_close($db);

?>
