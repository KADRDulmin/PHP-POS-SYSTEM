<?php
$host = 'vlvlnl1grfzh34vj.chr7pe7iynqr.eu-west-1.rds.amazonaws.com:3306';
$username = 'uyeoqi0xpq9hjg3z';
$password = 'mji9tjfqudu6uv8v';
$database = 'lpt4uru6tyzqk129';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "Connected successfully\n";

    // Files to import in order
    $files = [
        'heroku_db_import.sql' => 'regular',
        'triggers.sql' => 'trigger',
        'procedures.sql' => 'procedure'
    ];

    foreach ($files as $file => $type) {
        echo "\nImporting $file...\n";
        $sql = file_get_contents($file);

        try {
            switch ($type) {
                case 'trigger':
                case 'procedure':
                    // Execute as a single statement with custom delimiter
                    $pdo->exec("DELIMITER //");
                    $pdo->exec($sql);
                    $pdo->exec("DELIMITER ;");
                    break;
                case 'regular':
                    // Split and execute each statement separately
                    $statements = array_filter(array_map('trim', explode(';', $sql)));
                    foreach ($statements as $statement) {
                        if (!empty($statement)) {
                            try {
                                $pdo->exec($statement);
                            } catch (PDOException $e) {
                                echo "Warning on statement: " . $e->getMessage() . "\n";
                            }
                        }
                    }
                    break;
            }
            echo "Successfully imported $file\n";
        } catch (PDOException $e) {
            echo "Error importing $file: " . $e->getMessage() . "\n";
        }
    }

    echo "\nDatabase import completed!\n";
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
