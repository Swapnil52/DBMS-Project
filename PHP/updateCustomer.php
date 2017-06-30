<?php

$newName = "";
$number = "";
$newAddress = "";
$newRegion = "";

if (isset($_GET["newName"]))
{

	$newName = $_GET["newName"];

}

if (isset($_GET["number"]))
{

	$number = $_GET["number"];

}

if (isset($_GET["newAddress"]))
{

	$newAddress = rawurldecode($_GET["newAddress"]);

}

if (isset($_GET["newRegion"]))
{

	$newRegion = rawurldecode($_GET["newRegion"]);

}

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Error connecting to server');

mysqli_query($db, "start transaction");

$query = "update customer set C_name = '$newName', Street = '$newAddress', O_name = '$newRegion' where Phone = '$number'";

$result = mysqli_query($db, $query);

if ($result)
{

	mysqli_query($db, "commit");
	
	$query = "select * from Customer where Phone = '$number'";

	$result = mysqli_query($db, $query);

	$r = array();

	while($row = mysqli_fetch_array($result))
	{

		array_push($r, $row);

	}

	echo json_encode($r);

}
else 
{

	mysqli_query($db, "rollback");
	$r = array("Success" => 0);
	echo json_encode($r);

}

mysqli_close($db);

?>