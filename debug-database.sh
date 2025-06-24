#!/bin/bash

# Script Debug Database untuk Laravel di Hostinger
echo "🔍 Debugging Database Connection..."
echo "=================================="

# 1. Cek file .env
echo "1. 📄 Checking .env file..."
if [ -f ".env" ]; then
    echo "✅ File .env ditemukan"
    echo "📋 Database configuration:"
    grep -E "^DB_" .env
else
    echo "❌ File .env tidak ditemukan!"
    exit 1
fi

echo ""

# 2. Test koneksi database dengan detail
echo "2. 🔌 Testing database connection..."
php -r "
try {
    \$env = file_get_contents('.env');
    preg_match('/DB_HOST=(.*)/', \$env, \$host);
    preg_match('/DB_DATABASE=(.*)/', \$env, \$database);
    preg_match('/DB_USERNAME=(.*)/', \$env, \$username);
    preg_match('/DB_PASSWORD=(.*)/', \$env, \$password);
    
    echo 'Host: ' . trim(\$host[1]) . PHP_EOL;
    echo 'Database: ' . trim(\$database[1]) . PHP_EOL;
    echo 'Username: ' . trim(\$username[1]) . PHP_EOL;
    echo 'Password: ' . (trim(\$password[1]) ? '[SET]' : '[EMPTY]') . PHP_EOL;
    echo PHP_EOL;
    
    \$pdo = new PDO(
        'mysql:host=' . trim(\$host[1]) . ';dbname=' . trim(\$database[1]),
        trim(\$username[1]),
        trim(\$password[1])
    );
    echo '✅ Database connection: SUCCESS' . PHP_EOL;
    
    // Test query
    \$stmt = \$pdo->query('SELECT DATABASE() as current_db');
    \$result = \$stmt->fetch();
    echo '📊 Current database: ' . \$result['current_db'] . PHP_EOL;
    
} catch(Exception \$e) {
    echo '❌ Database connection: FAILED' . PHP_EOL;
    echo '🚨 Error: ' . \$e->getMessage() . PHP_EOL;
}
"

echo ""

# 3. Cek Laravel database connection
echo "3. 🎯 Laravel database connection test..."
php artisan tinker --execute="
try {
    \$pdo = DB::connection()->getPdo();
    echo '✅ Laravel DB connection: SUCCESS' . PHP_EOL;
    echo '📊 Database name: ' . DB::connection()->getDatabaseName() . PHP_EOL;
} catch(Exception \$e) {
    echo '❌ Laravel DB connection: FAILED' . PHP_EOL;
    echo '🚨 Error: ' . \$e->getMessage() . PHP_EOL;
}
"

echo ""

# 4. Cek migration status
echo "4. 📋 Migration status..."
php artisan migrate:status

echo ""

# 5. Cek tables di database
echo "5. 🗄️  Checking tables in database..."
php artisan tinker --execute="
try {
    \$tables = DB::select('SHOW TABLES');
    if(count(\$tables) > 0) {
        echo '✅ Tables found:' . PHP_EOL;
        foreach(\$tables as \$table) {
            \$tableName = array_values((array)\$table)[0];
            echo '  - ' . \$tableName . PHP_EOL;
        }
    } else {
        echo '❌ No tables found in database' . PHP_EOL;
    }
} catch(Exception \$e) {
    echo '❌ Error checking tables: ' . \$e->getMessage() . PHP_EOL;
}
"

echo ""

# 6. Cek data di table posts (jika ada)
echo "6. 📝 Checking posts table data..."
php artisan tinker --execute="
try {
    \$count = DB::table('posts')->count();
    echo '✅ Posts table found with ' . \$count . ' records' . PHP_EOL;
    
    if(\$count > 0) {
        \$posts = DB::table('posts')->get();
        foreach(\$posts as \$post) {
            echo '  - ' . \$post->title . ' (' . \$post->status . ')' . PHP_EOL;
        }
    }
} catch(Exception \$e) {
    echo '❌ Posts table check failed: ' . \$e->getMessage() . PHP_EOL;
}
"

echo ""
echo "🔍 Debug selesai!"
echo ""
echo "💡 Tips troubleshooting:"
echo "   - Jika connection FAILED, cek kredensial database di hPanel"
echo "   - Jika migration status kosong, jalankan: php artisan migrate --force"
echo "   - Jika tables tidak ada, coba: php artisan migrate:refresh" 