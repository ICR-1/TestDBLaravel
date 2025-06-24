# Laravel untuk Hostinger Shared Hosting

Panduan lengkap untuk menjalankan Laravel di Hostinger shared hosting dengan PHP 8.2.28 dan MySQL.

## 📋 Persyaratan

- Hostinger Shared Hosting dengan PHP 8.2.28
- Akses SSH (tersedia di paket Premium dan Business)
- Database MySQL
- Domain yang sudah dikonfigurasi

## 📁 File Tambahan yang Disediakan

Proyek ini sudah dilengkapi dengan file-file khusus untuk shared hosting:

- `hostinger-config.txt` - Template konfigurasi .env untuk Hostinger
- `deploy.sh` - Script otomatis untuk deployment
- `fix-permissions.sh` - Script untuk mengatur permission file
- `public/.htaccess` - Konfigurasi Apache yang dioptimasi
- Contoh migration dan model (Posts) untuk testing database

## 🚀 Langkah-langkah Instalasi

### 1. Persiapan File di Local

1. **Download atau clone proyek ini ke komputer lokal**
2. **Salin konfigurasi environment:**
   ```bash
   cp hostinger-config.txt .env
   ```
3. **Generate APP_KEY:**
   ```bash
   php artisan key:generate
   ```

### 2. Konfigurasi Database di Hostinger

1. **Login ke hPanel Hostinger**
2. **Buat database MySQL:**
   - Pergi ke **Websites** → **Database**
   - Klik **Create Database**
   - Nama database: `u123456789_namaproject`
   - Username: `u123456789_user`
   - Password: (buat password yang kuat)

### 3. Konfigurasi File .env

Edit file `.env` dengan informasi berikut:

```env
APP_NAME="Nama Aplikasi Anda"
APP_ENV=production
APP_KEY=base64:xxx (akan dihasilkan otomatis)
APP_DEBUG=false
APP_URL=https://yourdomain.com

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=u123456789_namaproject
DB_USERNAME=u123456789_user
DB_PASSWORD=password_database_anda

# Mail Configuration (opsional)
MAIL_MAILER=smtp
MAIL_HOST=smtp.hostinger.com
MAIL_PORT=587
MAIL_USERNAME=your_email@yourdomain.com
MAIL_PASSWORD=your_email_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your_email@yourdomain.com
```

## 📂 Upload ke Hostinger

### Metode 1: Menggunakan File Manager

1. **Compress proyek:**
   - Zip seluruh folder proyek Laravel
   - Upload file zip ke `public_html` via File Manager

2. **Extract file:**
   - Extract zip file di `public_html`
   - Pindahkan isi folder Laravel ke root `public_html`

### Metode 2: Menggunakan FTP/SFTP

1. **Koneksi FTP:**
   - Host: your-domain.com atau IP server
   - Username: username cPanel Anda
   - Password: password cPanel Anda
   - Port: 21 (FTP) atau 22 (SFTP)

2. **Upload file:**
   - Upload semua file ke folder `public_html`

## 🔧 Konfigurasi SSH dan Migrasi

### 1. Akses SSH ke Hostinger

```bash
ssh username@your-domain.com
# atau
ssh username@server-ip-address
```

**Informasi SSH dapat ditemukan di:**
- hPanel → Advanced → SSH Access

### 2. Navigasi ke Direktori Web

```bash
cd public_html
```

### 3. Jalankan Script Deployment Otomatis

```bash
# Buat script executable
chmod +x deploy.sh

# Jalankan deployment otomatis
./deploy.sh
```

### 4. Atau Manual Installation

```bash
# Cek versi PHP
php -v

# Install Composer dependencies (jika belum ter-upload)
composer install --optimize-autoloader --no-dev

# Set permissions
chmod -R 755 storage bootstrap/cache
chmod -R 777 storage/logs
chmod -R 777 storage/framework

# Generate application key
php artisan key:generate

# Clear dan cache configuration
php artisan config:clear
php artisan config:cache
```

### 5. Jalankan Database Migration

```bash
# Cek koneksi database
php artisan migrate:status

# Jalankan migration
php artisan migrate

# Jalankan seeder contoh (opsional)
php artisan db:seed
```

### 6. Fix Permission (jika diperlukan)

```bash
# Jalankan script fix permission
chmod +x fix-permissions.sh
./fix-permissions.sh
```

## 🧪 Testing Database

Proyek ini sudah dilengkapi dengan contoh migration dan seeder:

- **Model Post** dengan migration `create_posts_table`
- **PostSeeder** dengan data contoh
- **Scope methods** untuk query published/draft posts

Setelah menjalankan migration dan seeder, Anda dapat memeriksa data di database MySQL Anda.

## 🛠️ Troubleshooting

### Masalah Umum dan Solusi

#### 1. Error Composer Version (composer-runtime-api ^2.2)

**Penyebab:**
- Hostinger menggunakan Composer 1.x yang deprecated
- Laravel 12.x memerlukan Composer 2.x

**Solusi A - Skip Composer Install (Recommended untuk Shared Hosting):**
```bash
# Upload vendor folder dari local development
# Atau gunakan alternatif deployment tanpa composer install

# Edit script deploy.sh, comment bagian composer install:
# Buka file deploy.sh dan tambahkan # di depan baris composer install
```

**Solusi B - Upgrade Composer (jika memungkinkan):**
```bash
# Cek versi composer saat ini
composer --version

# Download composer 2.x (jika ada akses)
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Atau gunakan composer2 jika tersedia
composer2 install --optimize-autoloader --no-dev
```

**Solusi C - Manual Upload Dependencies:**
```bash
# Di local development, jalankan:
composer install --optimize-autoloader --no-dev

# Upload seluruh folder vendor/ ke server via FTP/File Manager
# Kemudian di server, skip bagian composer install
```

#### 2. Migration Hanging/Tidak Selesai

**Penyebab:**
- Koneksi database belum dikonfigurasi
- File .env belum diisi dengan benar
- Database belum dibuat di hPanel

**Solusi:**
```bash
# 1. Pastikan database sudah dibuat di hPanel Hostinger
# 2. Edit file .env dengan kredensial database yang benar
nano .env

# 3. Test koneksi database
php artisan tinker
# Dalam tinker, jalankan: DB::connection()->getPdo();
# Jika berhasil, akan menampilkan PDO object

# 4. Cek status migration
php artisan migrate:status

# 5. Jalankan migration satu per satu jika diperlukan
php artisan migrate --step

# 6. Jika masih error, reset dan migrate ulang
php artisan migrate:reset
php artisan migrate
```

#### 3. Script Deploy.sh Gagal

**Modifikasi script untuk skip composer:**

Buat file `deploy-no-composer.sh`:
```bash
#!/bin/bash

echo "🚀 Memulai deployment Laravel untuk Hostinger (tanpa composer)..."

# Cek apakah berada di direktori yang benar
if [ ! -f "artisan" ]; then
    echo "❌ Error: File artisan tidak ditemukan."
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
    exit 1
fi

# Skip composer install untuk shared hosting
echo "⚠️  Skipping composer install (gunakan vendor dari local)"

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

# Link storage
echo "🔗 Create storage link..."
php artisan storage:link

echo ""
echo "✅ Deployment selesai!"
echo ""
echo "📋 Langkah selanjutnya:"
echo "1. Pastikan file .env sudah diisi dengan benar"
echo "2. Test koneksi: php artisan tinker -> DB::connection()->getPdo();"
echo "3. Jalankan: php artisan migrate"
echo "4. Jalankan: php artisan db:seed"
```

#### 4. Error 500 Internal Server Error

**Penyebab:**
- File .env tidak dikonfigurasi dengan benar
- Permission folder storage salah
- APP_KEY belum di-generate

**Solusi:**
```bash
# Set permission yang benar
chmod -R 755 storage bootstrap/cache
chmod -R 777 storage/logs

# Generate key
php artisan key:generate

# Clear cache
php artisan config:clear
php artisan cache:clear
```

#### 5. Database Connection Error

**Penyebab:**
- Kredensial database salah
- Database belum dibuat

**Solusi:**
```bash
# 1. Periksa kredensial di hPanel Hostinger
# 2. Edit file .env:
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=u950839741_nama_database
DB_USERNAME=u950839741_username
DB_PASSWORD=password_anda

# 3. Test koneksi
php artisan tinker
DB::connection()->getPdo();
```

#### 6. Migration Error

**Solusi:**
```bash
# Reset migration (hati-hati: akan menghapus data)
php artisan migrate:reset

# Atau rollback step by step
php artisan migrate:rollback

# Jalankan ulang migration
php artisan migrate
```

#### 7. Permission Denied

**Solusi:**
```bash
# Jalankan script fix permission
./fix-permissions.sh

# Atau manual:
chown -R username:username /public_html
find public_html -type f -exec chmod 644 {} \;
find public_html -type d -exec chmod 755 {} \;
chmod -R 777 storage
```

## 🚨 **Panduan Khusus untuk Masalah Composer di Hostinger**

### Metode 1: Upload Vendor Manual (Recommended)

1. **Di komputer lokal:**
   ```bash
   composer install --optimize-autoloader --no-dev
   ```

2. **Upload folder vendor/** ke server via File Manager atau FTP

3. **Di server, gunakan script tanpa composer:**
   ```bash
   chmod +x deploy-no-composer.sh
   ./deploy-no-composer.sh
   ```

### Metode 2: Downgrade Laravel (jika diperlukan)

Jika tetap ingin menggunakan Composer 1.x di server:

1. **Edit composer.json** di local untuk kompatibilitas:
   ```json
   {
       "require": {
           "php": "^8.1",
           "laravel/framework": "^10.0"
       }
   }
   ```

2. **Update dependencies:**
   ```bash
   composer update
   ```

3. **Upload ulang ke server**

## 📝 Perintah Artisan yang Berguna

```bash
# Informasi aplikasi
php artisan about

# Membuat controller
php artisan make:controller NamaController

# Membuat model dengan migration
php artisan make:model NamaModel -m

# Membuat migration
php artisan make:migration create_nama_table

# Melihat status migration
php artisan migrate:status

# Rollback migration terakhir
php artisan migrate:rollback

# Refresh database (reset + migrate)
php artisan migrate:refresh

# Seed database
php artisan db:seed

# Membuat seeder
php artisan make:seeder NamaSeeder

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Maintenance mode
php artisan down
php artisan up
```

## 🔒 Security Best Practices

1. **Jangan expose file .env**
2. **Set APP_DEBUG=false di production**
3. **Gunakan HTTPS**
4. **Update Laravel secara berkala**
5. **Backup database secara rutin**
6. **Set permission file yang tepat (lihat fix-permissions.sh)**

## 📞 Support

Jika mengalami masalah:
1. Cek log error di `storage/logs/laravel.log`
2. Periksa error log di cPanel
3. Hubungi support Hostinger jika diperlukan

## 📚 Dokumentasi Tambahan

- [Laravel Documentation](https://laravel.com/docs)
- [Hostinger Help Center](https://support.hostinger.com)
- [PHP 8.2 Documentation](https://www.php.net/releases/8.2/en.php)

---

**Dibuat untuk:** Hostinger Shared Hosting dengan PHP 8.2.28  
**Laravel Version:** Latest  
**Database:** MySQL  
**Include:** Migration contoh, Seeder, Script deployment otomatis
