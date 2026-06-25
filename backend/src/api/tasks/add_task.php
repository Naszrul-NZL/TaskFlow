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

$user_id     = $data['user_id'];
$category_id = $data['category_id'];
$title       = $data['title'];
$description = $data['description'];
$priority    = $data['priority'];
$deadline    = $data['deadline'];

if (empty($user_id) || empty($title)) {
    echo json_encode(["success" => false, "message" => "User ID and title are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("INSERT INTO tasks (user_id, category_id, title, description, priority, deadline) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->execute([$user_id, $category_id, $title, $description, $priority, $deadline]);

$taskId = $pdo->lastInsertId();

echo json_encode([
    "success" => true,
    "message" => "Task added successfully",
    "data" => [
        "id"          => $taskId,
        "user_id"     => $user_id,
        "category_id" => $category_id,
        "title"       => $title,
        "description" => $description,
        "priority"    => $priority,
        "deadline"    => $deadline
    ]
]);