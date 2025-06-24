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

#### 1. Error 500 Internal Server Error

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

#### 2. Database Connection Error

**Penyebab:**
- Kredensial database salah
- Database belum dibuat

**Solusi:**
- Periksa kembali informasi database di .env
- Pastikan database sudah dibuat di hPanel

#### 3. Migration Error

**Solusi:**
```bash
# Reset migration (hati-hati: akan menghapus data)
php artisan migrate:reset

# Atau rollback step by step
php artisan migrate:rollback

# Jalankan ulang migration
php artisan migrate
```

#### 4. Permission Denied

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
