<?php
function getDB() {
    $dbPath = 'C:/xampp/htdocs/TaskFlow/db/database.sqlite';
    
    try {
        $pdo = new PDO("sqlite:" . $dbPath);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        
        // Enable foreign key support (SQLite has it off by default)
        $pdo->exec("PRAGMA foreign_keys = ON");
        
        return $pdo;
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Database connection failed: " . $e->getMessage()
        ]);
        exit();
    }
}