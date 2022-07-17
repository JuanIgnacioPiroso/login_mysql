<?php 
	$db = mysqli_connect('localhost','root','','flutter_login');

	$email = $_POST['email'];
	$contraseña = $_POST['contraseña'];

	$sql = "SELECT * FROM usuarios WHERE email = '".$email."' AND contraseña = '".$contraseña."'";

	$result = mysqli_query($db,$sql);
	$count = mysqli_num_rows($result);

	if ($count == 1) {
		echo json_encode('Success');
	}else{
		echo json_encode('Error');
	}
