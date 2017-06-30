<?php

$region = "";
if (isset($_GET['region']))
{
	$region = rawurldecode($_GET['region']);
}
$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Eng to mysql server');
$query = "select * from (food_items natural join Outlet) where O_name = '$region'";
$result = mysqli_query($db, $query) or die ('Query error');
$r = array();
while($row = mysqli_fetch_array($result))
{
	// echo $row['sname'].' '.$row['sid'];
	array_push($r, $row);
}

echo json_encode($r);

mysqli_close($db);

?>