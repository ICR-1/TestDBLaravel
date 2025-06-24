#!/bin/bash

# Script untuk mengatur permission file Laravel di shared hosting
echo "🔐 Mengatur permission file untuk shared hosting..."

# Set permission untuk direktori
find . -type d -exec chmod 755 {} \;
echo "✅ Permission direktori diatur ke 755"

# Set permission untuk file
find . -type f -exec chmod 644 {} \;
echo "✅ Permission file diatur ke 644"

# Set permission khusus untuk storage dan cache
chmod -R 777 storage/
chmod -R 777 bootstrap/cache/
echo "✅ Permission storage dan bootstrap/cache diatur ke 777"

# Set permission executable untuk artisan
chmod +x artisan
echo "✅ Permission artisan diatur sebagai executable"

# Set permission untuk script deployment
chmod +x deploy.sh
chmod +x fix-permissions.sh
echo "✅ Permission script deployment diatur sebagai executable"

# Pastikan file .env aman
if [ -f ".env" ]; then
    chmod 600 .env
    echo "✅ Permission file .env diatur ke 600 (aman)"
fi

echo ""
echo "🎉 Semua permission telah diatur dengan benar untuk shared hosting!"
echo ""
echo "📝 Ringkasan permission:"
echo "   - Direktori: 755"
echo "   - File: 644"
echo "   - Storage: 777"
echo "   - Bootstrap/cache: 777"
echo "   - Artisan: executable"
echo "   - .env: 600 (hanya owner yang bisa baca/tulis)" 