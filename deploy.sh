#!/bin/bash

# Script Deployment Laravel untuk Hostinger Shared Hosting
# Jalankan script ini setelah upload file ke server

echo "🚀 Memulai deployment Laravel untuk Hostinger..."

# Cek apakah berada di direktori yang benar
if [ ! -f "artisan" ]; then
    echo "❌ Error: File artisan tidak ditemukan. Pastikan Anda berada di direktori root Laravel."
    exit 1
fi

# Backup file .env jika ada
if [ -f ".env" ]; then
    echo "📄 Backup file .env..."
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
fi

# Salin konfigurasi template jika .env tidak ada
if [ ! -f ".env" ]; then
    echo "📝 Membuat file .env dari template..."
    cp hostinger-config.txt .env
    echo "⚠️  PENTING: Edit file .env dengan informasi database Anda!"
fi

# Install dependencies (jika composer tersedia)
if command -v composer &> /dev/null; then
    echo "📦 Install Composer dependencies..."
    composer install --optimize-autoloader --no-dev --no-interaction
else
    echo "⚠️  Composer tidak ditemukan. Pastikan dependencies sudah ter-upload."
fi

# Generate application key
echo "🔑 Generate application key..."
php artisan key:generate --force

# Set permissions
echo "🔐 Set file permissions..."
chmod -R 755 storage bootstrap/cache
chmod -R 777 storage/logs storage/framework

# Clear dan cache konfigurasi
echo "🧹 Clear cache..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Cache konfigurasi untuk production
echo "⚡ Cache konfigurasi..."
php artisan config:cache

# Link storage (jika diperlukan)
echo "🔗 Create storage link..."
php artisan storage:link

# Cek status migration
echo "🗄️  Cek status database..."
php artisan migrate:status

echo ""
echo "✅ Deployment selesai!"
echo ""
echo "📋 Langkah selanjutnya:"
echo "1. Edit file .env dengan informasi database Anda"
echo "2. Jalankan: php artisan migrate"
echo "3. Jalankan: php artisan db:seed (jika ada seeder)"
echo ""
echo "🌐 Akses website Anda di browser untuk memastikan semuanya berjalan dengan baik." 