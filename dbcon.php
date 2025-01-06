<?php
if (getenv("JAWSDB_URL")) {
    $url = parse_url(getenv("JAWSDB_URL"));

    if ($url && isset($url["host"], $url["user"], $url["pass"], $url["path"])) {
        $conn = mysqli_connect(
            $url["host"],
            $url["user"],
            $url["pass"],
            ltrim($url["path"], '/'),
            3306
        );
    } else {
        error_log("Invalid JAWSDB_URL environment variable. Falling back to localhost.");
        $conn = mysqli_connect("localhost", "root", "mysql", "possystem");
    }
} else {
    $conn = mysqli_connect("localhost", "root", "", "possystem");
}

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
