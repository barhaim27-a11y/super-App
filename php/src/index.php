<?php
$host = getenv('DB_HOST') ?: 'db';
$port = getenv('DB_PORT') ?: '3306';
$db   = getenv('DB_NAME') ?: 'super_app';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASSWORD') ?: 'password';

echo "<h1>PHP service is up ✅</h1>";
echo "<p>Go to / for Node (port 3000) and here for PHP (port 80).</p>";

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    $stmt = $pdo->query("SELECT NOW() AS now");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "<p><strong>DB connection:</strong> OK</p>";
    echo "<p><strong>NOW():</strong> " . htmlspecialchars($row['now']) . "</p>";
} catch (Throwable $e) {
    http_response_code(500);
    echo "<p><strong>DB connection:</strong> ERROR</p>";
    echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
}
