# Oracle Autonomous DB(ATP)接続設定

`laravel/demo/config/database.php` のデータベース項目を以下のように書き換える ※今回は書換済

```php
'default' => env('DB_CONNECTION', 'oracle'),
```

また、 `laravel/demo/config/oracle.php` に接続情報を書き込む

```php
        'driver'         => 'oracle',
        'tns'            => "XXXXXXXXXX_TP",                 # サービス名
        'host'           => env('DB_HOST', ''),
        'port'           => env('DB_PORT', '1521'),
        'database'       => env('DB_DATABASE', ''),
        'username'       => 'USERNAME',                      # 接続ユーザー名
        'password'       => 'PASSWORD',                      # パスワード
        'charset'        => env('DB_CHARSET', 'AL32UTF8'),
        'prefix'         => env('DB_PREFIX', ''),
        'prefix_schema'  => env('DB_SCHEMA_PREFIX', ''),
        'edition'        => env('DB_EDITION', 'ora$base'),
        'server_version' => env('DB_SERVER_VERSION', '18c'), # OracleDatabaseのバージョン
```


# migration
`laravel/demo` ディレクトリに移動し、下記コマンドを実行

```bash
$ php artisan migrate
```

# サーバーの起動

```bash
$ php artisan serve --host 0.0.0.0
```

