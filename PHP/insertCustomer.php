<?php

$name = "";
$region = "";
$phoneNumber = "";
$streetAddress = "";

if (isset($_GET["name"]))
{
	
	$name = rawurldecode($_GET["name"]);

}
if (isset($_GET["region"]))
{

	$region = rawurldecode($_GET["region"]);

}
if (isset($_GET["phoneNumber"]))
{

	$phoneNumber = rawurldecode($_GET["phoneNumber"]);

}
if (isset($_GET["streetAddress"]))
{

	$streetAddress = rawurldecode($_GET["streetAddress"]);

}

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Error connecting to mysql server');
$query = "insert into Customer (Phone, C_name, O_name, Street) values ('$phoneNumber', '$name', '$region', '$streetAddress')";

$result = mysqli_query($db, $query) or die ('');

$query = "select * from Customer where Phone = '$phoneNumber'";

$result = mysqli_query($db, $query);

$r = array();
while($row = mysqli_fetch_array($result))
{
	// echo $row['sname'].' '.$row['sid'];
	array_push($r, $row);
}

echo json_encode($r);

mysqli_close($db);

?>