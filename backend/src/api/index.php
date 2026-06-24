<?php
header("Content-Type: application/json");

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