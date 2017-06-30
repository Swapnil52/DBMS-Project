<?php

$db = mysqli_connect('127.0.0.1', 'root', '', 'DBMS Project') or die('Could not to mysql server');
$region = "";
$number = "";
$query = "";

mysqli_query($db, "start transaction;");

if (isset($_GET))
{
	foreach ($_GET as $key => $value) {
		
		if ($key == 'region')
		{

			$region = $value;
			continue;

		}
		else if ($key == 'number')
		{

			$number = $value;

		}
		else 
		{

			$query = "insert into cart (Phone, F_id, Qty, O_name) values ('$number', '$key', $value, '$region');";
			$flag = mysqli_query($db, $query) or die('Query Error');
			if (!$flag)
			{

				break;

			}

		}

	}
}

if ($flag)
{

	mysqli_query($db, "commit;");
	echo json_encode(array("Success" => 1));

}
else 
{
	mysqli_query($db, "rollback;");
	echo json_encode(array("Success" => 0));

}

mysqli_close($db);

?>