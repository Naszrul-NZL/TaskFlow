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

$name     = $data['name'];
$email    = $data['email'];
$password = $data['password'];

if (empty($name) || empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "All fields are required"]);
    exit();
}

$pdo = getDB();

$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    echo json_encode(["success" => false, "message" => "Email already registered"]);
    exit();
}

$stmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
$stmt->execute([$name, $email, $password]);

$userId = $pdo->lastInsertId();

echo json_encode([
    "success" => true,
    "message" => "User registered successfully",
    "data" => [
        "id"    => $userId,
        "name"  => $name,
        "email" => $email
    ]
]);