# テーブルの作成

以下のSQLを実行してテーブルとシーケンスを作成する。

ツールは問わないが、Oracle MLを利用するとブラウザからSQLを実行できる。  
[Oracle MLの利用方法はこちら](https://github.com/oracle-japan/code19-coding-hol/blob/master/common/Lab3-ExtensionLesson.md#oracle-ml%E3%82%92%E4%BD%BF%E3%81%86])

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
※プロファイルをお持ちでない方は、ログイン画面の [プロファイルの作成] からプロファイルを作成してください。

仮想マシンへログインし、Mavenのsettings.xmlファイルに認証情報を追加する。

```bash
# ssh -i ~/.ssh/code_tokyo_id_rsa opc@xx.xx.xx.xx
$ mkdir ~/.m2
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

## 2. データベースの接続設定を記載

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

## 3. 実行jarファイルを作成する

`code19-coding-hol/spring-boot` ディレクトリへ移動し、Mavenのパッケージコマンドを実行して、実行用のjarファイルを作成する。

```bash
$ cd code19-coding-hol/spring-boot
$ mvn package
```

これにより、実行用のjarファイルが `code19-coding-hol/spring-boot/target` ディレクトリに生成される。

## 4. アプリケーションを実行する

`code19-coding-hol/spring-boot/target` ディレクトリのjarファイルを実行する。  
Walletファイルを解凍したディレクトリパスの `TNS_ADMIN` の環境変数を利用するため、 `-E` オプションを使用して環境変数を引き継ぐこと。

```bash
$ cd code19-coding-hol/spring-boot/target
$ sudo -E java -jar demo-0.0.1-SNAPSHOT.jar
```

## 5. 起動確認

「5. アプリケーションを実行する」にてアプリケーションが80番ボートにて起動しているため、ブラウザから以下URLへアクセスすることで、サンプルアプリの動作確認が実行できる。  

`http://[仮想マシンのPublic IP]/`


# 補足1. 仮想マシンの環境構築について

本ハンズオンでは、アプリケーションを実行する仮想マシンにカスタムイメージを利用する。  

カスタムイメージはOracle Linux 7のOSイメージに対して、`code19setup.sh` のスクリプトを実行して作成した。

ここでは、 `code19setup.sh` のスクリプトのうち、spring bootを稼働させるために必要となる設定を抜粋して記載する。

本ハンズオンではJDKのバージョンやMavenの認証設定などを統一させるため、仮想マシンを本番環境兼ビルド環境として利用する。  
それにより、MavenやGitなど、ビルド環境にのみ必要なツールのインストールや設定もスクリプトにて実行している。  

参考 : [OracleのMavenリポジトリを利用するための設定](https://docs.oracle.com/middleware/1213/core/MAVEN/config_maven_repo.htm#MAVEN9010)

```shell
# ファイアウォールの設定を変更する
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

# ソース取得やビルドに必要なツールをインストールする
sudo yum -y install git
sudo yum -y install maven
# JDK11をインストールする
sudo yum -y install java-11-openjdk-devel
sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.3.7-0.0.1.el7_6.x86_64/bin/java

# Mavenでビルドするために、JAVA_HOMEにjdk11を指定
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"' >> ~/.bash_profile
# Autonomous DBの接続用Walletファイルの解凍ディレクトリパスをTNS_ADMINへ指定する
echo 'export TNS_ADMIN="/usr/local/etc/"' >> ~/.bash_profile
source ~/.bash_profile

# Maven経由でOracleのライセンス認証をし、jdbcなどをダウンロードするために必要な設定
sudo wget http://central.maven.org/maven2/org/apache/maven/wagon/wagon-http/2.8/wagon-http-2.8-shaded.jar -P /usr/share/maven/lib/ext/
```

jarファイルを実行するために必要な設定のみ抜粋したものは、以下の通り。

```shell
# ファイアウォールの設定を変更する
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

# JDK11をインストールする
sudo yum -y install java-11-openjdk-devel
sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.3.7-0.0.1.el7_6.x86_64/bin/java

# Autonomous DBの接続用Walletファイルの解凍ディレクトリパスをTNS_ADMINへ指定する
echo 'export TNS_ADMIN="/usr/local/etc/"' >> ~/.bash_profile
source ~/.bash_profile
```

# 補足2. アプリケーションの変更ポイント

### 1. OracleのMavenリポジトリを利用する設定をpom.xmlへ追記。  
https://github.com/oracle-japan/code19-coding-hol/blob/master/spring-boot/pom.xml#L69-L92

※[認証情報はこちらで設定。](https://github.com/oracle-japan/code19-coding-hol/blob/master/spring-boot/README.md#1-maven%E3%81%AE%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E8%A8%AD%E5%AE%9A%E3%82%92%E5%A4%89%E6%9B%B4)

### 2. ライブラリをpom.xmlのdependencyに追記。  
https://github.com/oracle-japan/code19-coding-hol/blob/master/spring-boot/pom.xml#L41-L65

[それぞれのライブラリの役割についての参考ページはこちら。](https://www.oracle.com/technetwork/jp/database/application-development/jdbc/overview/default-090281-ja.html#01_06)

## 3. IDにシーケンスを利用するようEntityを変更。
https://github.com/oracle-japan/code19-coding-hol/blob/master/spring-boot/src/main/java/com/example/demo/domain/Micropost.java#L10-L11

※[シーケンスはこちらで作成。](https://github.com/oracle-japan/code19-coding-hol/tree/master/spring-boot#%E3%83%86%E3%83%BC%E3%83%96%E3%83%AB%E3%81%AE%E4%BD%9C%E6%88%90)