<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once '../db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

$id      = $data['id'];
$user_id = $data['user_id'];
$name    = $data['name'];
$color   = $data['color'];

if (empty($id) || empty($user_id) || empty($name)) {
    echo json_encode(["success" => false, "message" => "ID, User ID and name are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("UPDATE categories SET name = ?, color = ? WHERE id = ? AND user_id = ?");
$stmt->execute([$name, $color, $id, $user_id]);

echo json_encode([
    "success" => true,
    "message" => "Category updated successfully"
]);