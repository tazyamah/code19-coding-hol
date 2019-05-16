# テーブルの作成

以下のSQLを実行してテーブルとシーケンスを作成する。

```sql
  CREATE TABLE "MICROPOSTS" 
   ("ID" NUMBER(38,0) NOT NULL ENABLE, 
	"CONTENT" CLOB COLLATE "USING_NLS_COMP");
```

```sql
CREATE SEQUENCE micropost_seq
  MINVALUE 1
  MAXVALUE 9999999999
  START WITH 1
  INCREMENT BY 1;
```

# Oracle Autonomous DB(ATP)接続設定と起動方法

## 1. Mavenのリポジトリ設定を変更

以下の URL にアクセスしてログインし、Oracle Maven Repositoryのライセンスを確認する。  
ライセンスを読み、同意いただける場合は [Accept License Agreement] を選択する。

https://www.oracle.com/webapps/maven/register/license.html

プロファイルをお持ちでない方は、ログイン画面の [プロファイルの作成] からプロファイルを作成してください。

仮想マシンへログインし、Mavenのsettings.xmlファイルを修正する。

```bash
# ssh -i ~/.ssh/code_tokyo_id_rsa opc@xx.xx.xx.xx
$ cp code19-coding-hol/spring-boot/maven-setting/settings.xml ~/.m2/
$ vim ~/.m2/settings.xml
```

`username` タグと `password` タグに、ログイン情報を記載する。

```xml
  <servers>
    <server>
      <id>maven.oracle.com</id>  
      <!-- TODO : Oracle Account UserName and Pass -->
      <username></username>
      <password></password>
      <configuration>
```

参考：本番環境にて利用する場合は、パスワードを暗号化されることをお勧めします。  
http://maven.apache.org/guides/mini/guide-encryption.html

## 2. Walletの取得・配置

Autonomous DBから取得したWalletファイルを仮想マシンへ転送する。

```bash
# scp -i ~/.ssh/code_tokyo_id_rsa Wallet_demo.zip opc@xx.xx.xx.xx:~
```

sshにて仮想マシンへログインし、Walletファイルを `/usr/local/etc/` ディレクトリへ解凍する。  
この `/usr/local/etc/` は環境変数 `TNS_ADMIN` に設定している。（TODO：参照を記載）

```bash
$ sudo cp Wallet_demo.zip /usr/local/etc/
$ sudo unzip Wallet_mugajin.zip -d /usr/local/etc
```

## 3. データベースの接続設定を記載

`code19-coding-hol/spring-boot/src/main/resources/application.properties` を以下の通り変更する。

```properties
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@[データベース接続名]_TP
spring.datasource.username=[データベース接続ユーザー名]
spring.datasource.password=[データベース接続ユーザーのパスワード]

server.port=80
```

設定例を以下に示す。

```properties
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@demo_TP
spring.datasource.username=MLUSER
spring.datasource.password=quu6nMQHRjKC43H

server.port=80
```

## 4. 実行jarファイルを作成する

`code19-coding-hol/spring-boot` ディレクトリへ移動し、Mavenのパッケージコマンドを実行して、実行用のjarファイルを作成する。

```bash
$ cd code19-coding-hol/spring-boot
$ mvn package
```

これにより、実行用のjarファイルが `code19-coding-hol/spring-boot/target` ディレクトリに生成される。

## 5. アプリケーションを実行する

`code19-coding-hol/spring-boot/target` ディレクトリのjarファイルを実行する。  
Walletファイルを解凍したディレクトリパスの `TNS_ADMIN` の環境変数を利用するため、 `-E` オプションを使用して環境変数を引き継ぐこと。

```bash
$ sudo -E java -jar demo-0.0.1-SNAPSHOT.jar
```

## 6. 起動確認

「5. アプリケーションを実行する」にてアプリケーションが80番ボートにて起動しているため、ブラウザから以下URLへアクセスすることで、サンプルアプリの動作確認が実行できる。
`http://[仮想マシンのPublic IP]/`


# 補足. 仮想マシンの環境構築について

本ハンズオンでは、アプリケーションを実行する仮想マシンにカスタムイメージを利用する。  

 (TODO : 記載)
カスタムイメージはOracle Linux 7のOSイメージに対して、`aa` のスクリプトを実行して作成した。
- ベースイメージのID : ``

ここでは、 `aa` のスクリプトのうち、spring bootを稼働させるために必要となる設定を抜粋して記載する。

本ハンズオンではJDKのバージョンやMavenの認証設定などを統一させるため、仮想マシンを本番環境兼ビルド環境として利用する。  
それにより、MavenやGitなど、ビルド環境にのみ必要なツールのインストールや設定もスクリプトにて実行している。  

```shell
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

sudo yum -y install git
sudo yum -y install maven
sudo yum -y install java-11-openjdk-devel
sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.3.7-0.0.1.el7_6.x86_64/bin/java

echo 'export TNS_ADMIN="/usr/local/etc/"' >> ~/.bash_profile
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"' >> ~/.bash_profile
source ~/.bash_profile

sudo wget http://central.maven.org/maven2/org/apache/maven/wagon/wagon-http/2.8/wagon-http-2.8-shaded.jar -P /usr/share/maven/lib/ext/
```

jarファイルを実行するために必要な設定のみ抜粋したものは、以下の通り。

```shell
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

sudo yum -y install java-11-openjdk-devel
sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.3.7-0.0.1.el7_6.x86_64/bin/java

echo 'export TNS_ADMIN="/usr/local/etc/"' >> ~/.bash_profile
```

