<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Method not allowed"]);
    exit();
}

require_once '../db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

$id      = $data['id'];
$user_id = $data['user_id'];

if (empty($id) || empty($user_id)) {
    echo json_encode(["success" => false, "message" => "ID and User ID are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("DELETE FROM tasks WHERE id = ? AND user_id = ?");
$stmt->execute([$id, $user_id]);

echo json_encode([
    "success" => true,
    "message" => "Task deleted successfully"
]);