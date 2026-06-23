<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once '../db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

$user_id = $data['user_id'];
$name    = $data['name'];
$color   = $data['color'];

if (empty($user_id) || empty($name)) {
    echo json_encode(["success" => false, "message" => "User ID and name are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("INSERT INTO categories (user_id, name, color) VALUES (?, ?, ?)");
$stmt->execute([$user_id, $name, $color]);

$categoryId = $pdo->lastInsertId();

echo json_encode([
    "success" => true,
    "message" => "Category added successfully",
    "data" => [
        "id"      => $categoryId,
        "user_id" => $user_id,
        "name"    => $name,
        "color"   => $color
    ]
]);