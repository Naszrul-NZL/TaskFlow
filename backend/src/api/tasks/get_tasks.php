<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once '../db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

$user_id = $data['user_id'];

if (empty($user_id)) {
    echo json_encode(["success" => false, "message" => "User ID is required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("SELECT * FROM tasks WHERE user_id = ?");
$stmt->execute([$user_id]);
$tasks = $stmt->fetchAll();

echo json_encode([
    "success" => true,
    "message" => "Tasks retrieved successfully",
    "data" => $tasks
]);