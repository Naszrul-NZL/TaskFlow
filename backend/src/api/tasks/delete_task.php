<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

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