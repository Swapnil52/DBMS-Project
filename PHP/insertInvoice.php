<?php

$Phone = "";
$Eid = "";
$CustomerName = "";
$Amount = "";
$Region = "";

if (isset($_GET["Phone"]))
{

	$Phone = $_GET["Phone"]; 

}

if (isset($_GET["Eid"]))
{

	$Eid = $_GET["Eid"]; 

}

if (isset($_GET["CustomerName"]))
{

	$CustomerName = $_GET["CustomerName"]; 

}

if (isset($_GET["Region"]))
{

	$Region = $_GET["Region"]; 

}

if (isset($_GET["Amount"]))
{

	$Amount = $_GET["Amount"]; 

}

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Eng to mysql server');

mysqli_query($db, "start transaction") or die ('Query error');

$query = "insert into Invoice (Phone, C_name, Amount, E_id, O_name) VALUES ('$Phone', '$CustomerName', $Amount, '$Eid', '$Region')";

$result = mysqli_query($db, $query) or die ('Query error');

if ($result)
{

	mysqli_query($db, "commit") or die ('Query error');

}
else 
{

	mysqli_query($db, "rollback") or die('Query error');

}

$r = array("Sucess" => 1, "Query" => $query);

echo json_encode($r);

mysqli_close($db);

?>