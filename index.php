<?php
require_once __DIR__ . '/vendor/autoload.php';
$router = require_once __DIR__ . '/routes/router.php';

$match = $router->match();

// Verificar si la ruta coincide
if ($match) {
    // Requerir el archivo que maneja la ruta
    require __DIR__ . '/' . $match['target'];
} else {
    // Ruta no encontrada
    header($_SERVER["SERVER_PROTOCOL"] . ' 404 Not Found');
    echo '<h3>404 Not Found</h3>';
}
