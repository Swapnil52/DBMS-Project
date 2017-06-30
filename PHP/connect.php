<?php

$number = "";

if (isset($_GET['number']))
{
	
	$number = $_GET['number'];

}

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Error connecting to server');

$query = "select * from Customer where Phone = $number";

$result = mysqli_query($db, $query);

if ($result)
{

	$r = array();

	while($row = mysqli_fetch_array($result))
	{
		
		array_push($r, $row);

	}
	
	echo json_encode($r);

}
else 
{

	$r = array(array("Success" => 0));

	echo json_encode($r);

}

mysqli_close($db);


?>