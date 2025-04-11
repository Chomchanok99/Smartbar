<?php
$host = "sql102.infinityfree.com";
$user = "if0_38725992";
$pass = "vSWaAjuojUe5";
$db = "if0_38725992_menu";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$result = $conn->query("SELECT * FROM menu");
$menu = array();

while ($row = $result->fetch_assoc()) {
    $menu[] = $row;
}

echo json_encode($menu);
?>
