<?php
require_once __DIR__ . '/../vendor/autoload.php';

$router = new AltoRouter();
$router->setBasePath('/hojisvl');

$router->map('GET', '/', 'modules/home/index.php');
// $router->map('GET', '/products', 'modules/products/index.php');
// $router->map('GET', '/login', 'modules/user/login.php');
// $router->map('GET', '/register', 'modules/user/register.php');

// Rutas para manejar AJAX requests (estos deberían ser POST probablemente)
// $router->map('POST', '/cart/ajax', 'modules/cart/ajax.php');
// $router->map('POST', '/products/ajax', 'modules/products/ajax.php');
// $router->map('POST', '/user/ajax', 'modules/user/ajax.php');

return $router;
