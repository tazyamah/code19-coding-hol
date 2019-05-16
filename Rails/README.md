# Oracle接続のRails環境構築について

環境構築のガイドです。

## Docker作成と実行

サンプルDockerfileは同一ディレクトリにあります。

```text
docker build -t oracle-code-tokyo/rails-atp:1.0 .

docker run -it -p 3000:3000 --name oracle-ruby-atp oracle-code-tokyo/rails-atp:1.0 /bin/bash --login

```


## インスタンス手動構成スクリプト

参考です。ここから下の構成はDocker及びカスタムイメージでは設定済み。



```text

echo 'export ORACLE_HOME="/usr/lib/oracle/18.5/client64"' >> ~/.bash_profile
echo 'export LD_LIBRARY_PATH="/usr/lib/oracle/18.5/client64/lib"' >> ~/.bash_profile
echo 'export TNS_ADMIN="/usr/local/etc"' >> ~/.bash_profile
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

cd; yum -y install git
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

一度抜ける

localPC$ docker start oracle-ruby-atp
localPC$ docker exec -it oracle-ruby-atp /bin/bash —login


sudo yum install -y gcc openssl-devel readline-devel zlib-devel sqlite-devel nodejs bzip2 make
rbenv install 2.6.3
rbenv global 2.6.3
mkdir /usr/local/app
cd /usr/local/app
gem install -N rails
```






# Oracle Autonomous DB(ATP)接続設定

### インスタンスの場合

ローカルPCからWalletのコピー

```text
scp -i ~/.ssh/code_tokyo_id_rsa Wallet_btamarirails.zip opc@132.145.115.14:
```

ターゲットインスタンスで以下実行

```text
localPC#  ssh opc@132.145.115.14 -i ~/.ssh/code_tokyo_id_rsa
sudo cp Wallet_btamarirails.zip /usr/local/etc/
cd /usr/local/etc/
sudo unzip Wallet_btamarirails.zip
sudo cp sqlnet.ora sqlnet.ora.org && cat sqlnet.ora.org | sudo sh -c "sed -e 'N;s/\?\/network\/admin/\/usr\/local\/etc/g' > sqlnet.ora"

```


### Dockerの場合

別ターミナルから、docker container idを確認

例　00407e328a55

```text
docker ps |grep oracle-code-tokyo/rails-atp | awk '{ print $1 }'
docker cp Wallet_btamarirails.zip 00407e328a55:/usr/local/etc
```


参考：複合スクリプト

```text
docker cp Wallet_btamarirails.zip `docker ps |grep oracle-code-tokyo/rails-atp | awk '{ print $1 }'`:/usr/local/etc

```


dockerにもどりWalletの解凍　sqlnet.oraの修正


```

cd /usr/local/etc/
unzip Wallet_btamarirails.zip

cp sqlnet.ora sqlnet.ora.org && cat sqlnet.ora.org | sed -e 'N;s/\?\/network\/admin/\/usr\/local\/etc/g' > sqlnet.ora
```

### Oracleへのコマンドからの接続確認

sqlplusで確認をします。

```text
sqlplus admin/Oracle123456@btamarirails_tp

Password: Oracle123456
```




### Rails動作確認

```
rails new toy_app && cd toy_app/ && rails s -b 0.0.0.0
curl localhost:3000
```

# Rails をOracle Autonomous DBで動かす

### Oracle Driver のインストール

GemfileにOracle用のGemを導入し、bundle installします。

``` ruby
# Use oracle as the database for Active Record
gem 'activerecord-oracle_enhanced-adapter', '~> 5.2.0'
gem 'ruby-oci8' # only for CRuby users
```

Oracle Driver追記スクリプト

``` bash
cd /usr/local/app/toy_app/
# sed -i -e "s/gem 'sqlite3'/\# gem 'sqlite3'/g" Gemfile

cat << 'EOS' | sed -i '9r /dev/stdin' Gemfile
# Oracle drivers
gem 'activerecord-oracle_enhanced-adapter', '~> 5.2.0'
gem 'ruby-oci8' # only for CRuby users
EOS


# Use oracle as the database for Active Record
```


#### Oracle Tips 10,000から始まるidを1から始まるように変更

https://doruby.jp/users/tips4tips/entries/RailsでOracle～-導入と文字列の扱いについて



Oracleのデフォルトではidが10000から始まるので、1から始まるように設定変更

``` ruby

cat <<EOS > config/initializers/oracle.rb
# It is recommended to set time zone in TZ environment variable so that the same timezone will be used by Ruby and by Oracle session
ENV['TZ'] = 'UTC'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    # true and false will be stored as 'Y' and 'N'
    self.emulate_booleans_from_strings = true

    # start primary key sequences from 1 (and not 10000) and take just one next value in each session
    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1"

    # Use old visitor for Oracle 12c database
    # self.use_old_oracle_visitor = true

    # other settings ...
  end
end
EOS
```

gemを有効化

```
bundle install
```

database.ymlを修正 tnsname.oraのtp設定を記入(二行にまたがっているので注意)

``` yaml
mv config/database.yml config/database.yml.org

cat <<EOS > config/database.yml
default: &default
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  adapter: oracle_enhanced
  username: USERNAME
  password: PASSWORD
  timeout: 5000
  encoding: utf8

development:
  <<: *default
  database: (description=(address=(protocol=tcps)(port=1522)(host=adb.ap-tokyo-1.oraclecloud.com))(connect_data=(service_name=hogehoge_btamarirails_tp.atp.oraclecloud.com))(security=(ssl_server_cert_dn="CN=adb.ap-tokyo-1.oraclecloud.com,OU=Oracle ADB TOKYO,O=Oracle Corporation,L=Redwood City,ST=California,C=US")))

test:
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  database: db/test.sqlite3

production:
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  database: db/production.sqlite3
EOS
```

### Rails + ATPで実際にアプリを動かす

```text
bundle install rails generate scaffold User name:string email:string
bundle install rails db:migrate

bundle install rails s -b 0.0.0.0
```

### Tips

- 順序が自動生成されているので、DB作り直しのときにSQL Developerから削除が必要でした。
- rails db:migrate:resetがうまくいかない場合があります。その場合もSQL Developerから処理します。

