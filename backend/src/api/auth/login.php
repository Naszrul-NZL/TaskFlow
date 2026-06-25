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

$email    = $data['email'];
$password = $data['password'];

if (empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "All fields are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user) {
    echo json_encode(["success" => false, "message" => "Email not found"]);
    exit();
}

if ($user['password'] !== $password) {
    echo json_encode(["success" => false, "message" => "Wrong password"]);
    exit();
}

echo json_encode([
    "success" => true,
    "message" => "Login successful",
    "data" => [
        "id"    => $user['id'],
        "name"  => $user['name'],
        "email" => $user['email']
    ]
]);