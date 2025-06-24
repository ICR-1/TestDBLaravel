#!/bin/bash

# Script Deployment Laravel untuk Hostinger (Tanpa Composer Install)
# Gunakan script ini jika mengalami masalah dengan Composer version

echo "🚀 Memulai deployment Laravel untuk Hostinger (tanpa composer)..."

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
    echo "⏸️  BERHENTI - Edit .env dulu sebelum melanjutkan!"
    echo ""
    echo "Contoh konfigurasi .env:"
    echo "DB_DATABASE=u950839741_nama_database"
    echo "DB_USERNAME=u950839741_username"
    echo "DB_PASSWORD=password_anda"
    echo ""
    echo "Setelah edit .env, jalankan script ini lagi."
    exit 1
fi

# Cek apakah vendor folder exists
if [ ! -d "vendor" ]; then
    echo "⚠️  Folder vendor tidak ditemukan!"
    echo "📦 Upload folder vendor dari local development atau jalankan composer install manual"
    echo "💡 Atau gunakan alternatif dengan composer2 jika tersedia:"
    echo "    composer2 install --optimize-autoloader --no-dev"
    echo ""
else
    echo "✅ Folder vendor ditemukan, melanjutkan deployment..."
fi

# Generate application key
echo "🔑 Generate application key..."
php artisan key:generate --force

# Set permissions
echo "🔐 Set file permissions..."
chmod -R 755 storage bootstrap/cache
chmod -R 777 storage/logs storage/framework

# Clear cache terlebih dahulu
echo "🧹 Clear cache..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Test koneksi database
echo "🗄️  Test koneksi database..."
php artisan tinker --execute="try { DB::connection()->getPdo(); echo 'Database connection: OK'; } catch(Exception \$e) { echo 'Database connection: FAILED - ' . \$e->getMessage(); }"

# Cache konfigurasi untuk production
echo "⚡ Cache konfigurasi..."
php artisan config:cache

# Link storage (jika diperlukan)
echo "🔗 Create storage link..."
php artisan storage:link

# Cek status migration
echo "📋 Cek status migration..."
php artisan migrate:status

echo ""
echo "✅ Deployment selesai!"
echo ""
echo "📋 Langkah selanjutnya:"
echo "1. Jika database connection FAILED, edit file .env dengan kredensial yang benar"
echo "2. Jalankan: php artisan migrate"
echo "3. Jalankan: php artisan db:seed (untuk data contoh)"
echo ""
echo "🌐 Akses website Anda di browser untuk memastikan semuanya berjalan dengan baik."
echo ""
echo "🔧 Jika masih ada masalah, jalankan:"
echo "   ./fix-permissions.sh" 