<?php

$Eid = "";
$region = "";
     
if (isset($_GET["Eid"]))
{

	$Eid = $_GET["Eid"]; 

}
     
if (isset($_GET["region"]))
{

	$region = $_GET["region"]; 

}
     

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Eng to mysql server');

mysqli_query($db, "start transaction") or die ('Query error');

$query = "select * from employee where E_id = '$Eid' and O_name = '$region'";

$result = mysqli_query($db, $query) or die ('Query error');

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

	$r = array("Sucess" => 0);

	echo json_encode($r);

}



mysqli_close($db);

?>