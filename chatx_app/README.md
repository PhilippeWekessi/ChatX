# ChatX Flutter application

## Getting Started

Start the Laravel backend from the repository root:

```sh
php artisan serve
```

For Flutter Web, allow the local Flutter development origin in the backend
`.env` file if you use a different web port:

```env
CORS_ALLOWED_ORIGINS=http://localhost:5000,http://127.0.0.1:5000
```

Run the app with the API URL when the backend is not using the default address:

```sh
flutter run -d chrome --dart-define=CHATX_API_BASE_URL=http://127.0.0.1:8000/api
```
