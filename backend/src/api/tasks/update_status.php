<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once '../db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

$id      = $data['id'];
$user_id = $data['user_id'];
$status  = $data['status'];

if (empty($id) || empty($user_id) || empty($status)) {
    echo json_encode(["success" => false, "message" => "ID, User ID and status are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("UPDATE tasks SET status = ? WHERE id = ? AND user_id = ?");
$stmt->execute([$status, $id, $user_id]);

echo json_encode([
    "success" => true,
    "message" => "Task status updated successfully"
]);