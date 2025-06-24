#!/bin/bash

# Script untuk memaksa migration dan seeding database
echo "🔧 Fixing Migration dan Database Setup..."
echo "======================================="

# 1. Clear semua cache
echo "1. 🧹 Clearing all cache..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# 2. Force migration
echo "2. 🗄️  Force migration..."
php artisan migrate --force

# 3. Cek status migration
echo "3. 📋 Migration status setelah force:"
php artisan migrate:status

# 4. Jika masih kosong, coba refresh migration
echo "4. 🔄 Checking if refresh needed..."
php artisan tinker --execute="
try {
    \$tables = DB::select('SHOW TABLES');
    if(count(\$tables) == 0) {
        echo '⚠️  No tables found, akan refresh migration...' . PHP_EOL;
    } else {
        echo '✅ Tables found: ' . count(\$tables) . ' tables' . PHP_EOL;
    }
} catch(Exception \$e) {
    echo '❌ Error: ' . \$e->getMessage() . PHP_EOL;
}
"

# 5. Jika diperlukan, reset dan migrate ulang
read -p "🤔 Apakah ingin reset dan migrate ulang? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Resetting dan migrating ulang..."
    php artisan migrate:reset --force
    php artisan migrate --force
fi

# 6. Seed database
echo "6. 🌱 Seeding database..."
php artisan db:seed --force

# 7. Final check
echo "7. ✅ Final check..."
php artisan tinker --execute="
try {
    \$tables = DB::select('SHOW TABLES');
    echo '📊 Total tables: ' . count(\$tables) . PHP_EOL;
    
    if(count(\$tables) > 0) {
        foreach(\$tables as \$table) {
            \$tableName = array_values((array)\$table)[0];
            echo '  - ' . \$tableName . PHP_EOL;
        }
    }
    
    // Cek data posts
    try {
        \$postsCount = DB::table('posts')->count();
        echo '📝 Posts records: ' . \$postsCount . PHP_EOL;
    } catch(Exception \$e) {
        echo '⚠️  Posts table not found' . PHP_EOL;
    }
    
} catch(Exception \$e) {
    echo '❌ Error: ' . \$e->getMessage() . PHP_EOL;
}
"

echo ""
echo "🎉 Migration fix selesai!"
echo "🌐 Cek database di hPanel Hostinger untuk memastikan tabel sudah ada." 