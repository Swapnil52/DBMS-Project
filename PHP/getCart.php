<?php

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project');

$number = "";

if (isset($_GET["number"]))
{

	$number = $_GET["number"];

}

$query = "select * from cart where Phone = '$number';";

$result = mysqli_query($db, $query);

$r = array();

while($row = mysqli_fetch_array($result))
{

	array_push($r, $row);

}

echo json_encode($r);

mysqli_close($db);

?>