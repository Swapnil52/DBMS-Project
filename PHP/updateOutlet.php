<?php

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Could not to mysql server');
$region = "";
$i = 0;
$query = "";

mysqli_query($db, "start transaction") or die("Query error");

$query = "";

if (isset($_GET))
{
	foreach ($_GET as $key => $value) {
		
		if ($key == 'region')
		{

			$region = $value;
			continue;

		}
		else 
		{

			$query = "update Outlet set Qty_sold = Qty_sold + $value where O_name = '$region' and F_id = '$key';";

			$flag = mysqli_query($db, $query) or die('Query error');

			if (!$flag)
			{

				mysqli_query($db, "rollback;");
				$r = array("Success" => 0);
				echo json_encode($r);

			}

		}

	}
}

if ($flag)
{

	mysqli_query($db, "commit") or die("Query error");
	$r = array("Success" => 1);
	echo json_encode($r);

}

mysqli_close($db);

?>