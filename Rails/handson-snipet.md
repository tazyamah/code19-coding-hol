Dockerスタート

```text
docker build -t oracle-code-tokyo/rails-atp:1.0 .

docker run -it -p 3000:3000 --name oracle-ruby-atp oracle-code-tokyo/rails-atp:1.0 /bin/bash --login

```


ここから下の構成は自動化済み
ーーー
```text
bash-4.2# cd; yum -y install git
bash-4.2# git clone git://github.com/sstephenson/rbenv.git .rbenv
bash-4.2# echo 'export LD_LIBRARY_PATH="/usr/lib/oracle/18.3/client64/lib"' >> ~/.bash_profile
bash-4.2# echo 'export TNS_ADMIN="/usr/etc"' >> ~/.bash_profile
bash-4.2# echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
bash-4.2# echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
bash-4.2# exec $SHELL
bash-4.2# git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
一度抜ける

tamaribungonoMacBook-Pro-3:code_tokyo damarinz$ docker start oracle-ruby-atp
tamaribungonoMacBook-Pro-3:code_tokyo damarinz$ docker exec -it oracle-ruby-atp /bin/bash —login
bash-4.2# yum install -y gcc openssl-devel readline-devel zlib-devel sqlite-devel nodejs bzip2 make
bash-4.2# rbenv install 2.6.3
bash-4.2# rbenv global 2.6.3
bash-4.2# mkdir /usr/local/app
bash-4.2# cd /usr/local/app
bash-4.2# gem install -N rails
```






# ATP接続

別ターミナルから、docker container idを確認
00407e328a55

docker ps |grep oracle-code-tokyo/rails-atp | awk '{ print $1 }'
docker cp Wallet_btamarirails.zip 00407e328a55:/usr/local/etc

複合スクリプト
docker cp Wallet_btamarirails.zip `docker ps |grep oracle-code-tokyo/rails-atp | awk '{ print $1 }'`:/usr/local/etc


dockerにもどりWalletの解凍　sqlnet.oraの修正


```

cd /usr/local/etc/
unzip Wallet_btamarirails.zip

cp sqlnet.ora sqlnet.ora.org && cat sqlnet.ora.org | sed -e 'N;s/\?\/network\/admin/\/usr\/local\/etc/g' > sqlnet.ora
```

接続確認

sqlplus admin/Oracle123456@btamarirails_tp

Password: Oracle123456



# Rails動作確認

```
rails new toy_app && cd toy_app/ && rails s -b 0.0.0.0
```

# Rails をOracleで動かす

### Gemfileに追加

```text
# Use oracle as the database for Active Record
gem 'activerecord-oracle_enhanced-adapter', '~> 5.2.0'
gem 'ruby-oci8' # only for CRuby users
```


```text
bundle install
```




### Oracle Driver のインストール

Gemfileのsqlite3ドライバーを外してOracle Driver追記


```
cd /usr/local/app/toy_app/
sed -i -e "s/gem 'sqlite3'/\# gem 'sqlite3'/g" Gemfile

cat << 'EOS' | sed -i '9r /dev/stdin' Gemfile
# Oracle drivers
gem 'activerecord-oracle_enhanced-adapter', '~> 5.2.0'
gem 'ruby-oci8' # only for CRuby users
EOS


# Use oracle as the database for Active Record
```



##### Oracle Tips
https://doruby.jp/users/tips4tips/entries/RailsでOracle～-導入と文字列の扱いについて


idを1から
```

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

database.ymlを修正 tnsname.oraのtp設定を記入

```
mv config/database.yml config/database.yml.org

cat <<EOS > config/database.yml
default: &default
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  adapter: oracle_enhanced
  username: admin
  password: Oracle123456
  timeout: 5000
  encoding: utf8

development:
  <<: *default
  database: (description=(address=(protocol=tcps)(port=1522)(host=adb.ap-tokyo-1.oraclecloud.com))(connect_data=(service_name=sya6vphk3pzlkhq_btamarirails_tp.atp.oraclecloud.com))(security=(ssl_server_cert_dn="CN=adb.ap-tokyo-1.oraclecloud.com,OU=Oracle ADB TOKYO,O=Oracle Corporation,L=Redwood City,ST=California,C=US")))

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


```text
rails generate scaffold User name:string email:string
rails db:migrate

rails s -b 0.0.0.0
```


Tip：順序が自動生成されているので、作り直しのときにSQL Developerから削除が必要

