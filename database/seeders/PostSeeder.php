<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Post;
use Illuminate\Support\Str;

class PostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $posts = [
            [
                'title' => 'Selamat Datang di Laravel!',
                'slug' => 'selamat-datang-di-laravel',
                'content' => 'Ini adalah post pertama di aplikasi Laravel Anda. Laravel adalah framework PHP yang powerful dan mudah digunakan untuk pengembangan web modern.',
                'status' => 'published',
                'author' => 'Admin',
                'published_at' => now(),
            ],
            [
                'title' => 'Panduan Deploy di Hostinger',
                'slug' => 'panduan-deploy-di-hostinger',
                'content' => 'Hostinger menyediakan shared hosting yang sangat baik untuk aplikasi Laravel. Dengan PHP 8.2.28 dan MySQL, Anda dapat menjalankan aplikasi Laravel dengan performa optimal.',
                'status' => 'published',
                'author' => 'Admin',
                'published_at' => now(),
            ],
            [
                'title' => 'Tips Optimasi Laravel di Shared Hosting',
                'slug' => 'tips-optimasi-laravel-di-shared-hosting',
                'content' => 'Beberapa tips untuk mengoptimalkan performa Laravel di shared hosting: gunakan cache, optimasi query database, dan konfigurasi yang tepat.',
                'status' => 'draft',
                'author' => 'Admin',
                'published_at' => null,
            ]
        ];

        foreach ($posts as $post) {
            Post::create($post);
        }
    }
}
