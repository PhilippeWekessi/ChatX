<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => array_filter(explode(
        ',',
        env('CORS_ALLOWED_ORIGINS', 'http://localhost:5000,http://127.0.0.1:5000')
    )),
    'allowed_origins_patterns' => [
        '^https?://(localhost|127\.0\.0\.1)(:\d+)?$',
    ],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
