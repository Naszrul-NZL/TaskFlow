<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}


try {
    $dbPath = 'C:/xampp/htdocs/TaskFlow/db/database.sqlite';
    $pdo = new PDO("sqlite:" . $dbPath);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo json_encode([
        "success" => true,
        "message" => "PHP is running and SQLite connection works!",
        "db_path" => $dbPath
    ]);
} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => "DB connection failed: " . $e->getMessage()
    ]);
}