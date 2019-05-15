# Oracle Autonomous DB(ATP)接続設定

`Django/demo/demo/settings.py` のデータベース項目を以下のように書き換える

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'XXXXXXXXXX_TP', # 利用したサービス名
        'USER': 'USERNAME',      # ユーザー名
        'PASSWORD': 'PASSWORD'   # パスワード
    }
}
```

# migration
`Django/demo` ディレクトリに移動し、下記コマンドを実行

```bash
$ python manage.py migrate
```

# サーバーの起動

```bash
$ python manage.py runserver 0.0.0.0:8000
```

