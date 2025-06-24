<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Konfigurasi khusus untuk shared hosting
        $middleware->trustProxies(at: '*');
        $middleware->validateCsrfTokens(except: [
            // Tambahkan route yang dikecualikan dari CSRF jika diperlukan
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Error handling untuk production
        if (app()->environment('production')) {
            $exceptions->render(function (Throwable $e) {
                // Custom error handling untuk shared hosting
                return response()->view('errors.500', [], 500);
            });
        }
    })->create();
