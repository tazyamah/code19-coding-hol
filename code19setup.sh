# locale
sudo sh -c 'echo -e "LANG=ja_JP.utf-8\nLC_ALL=ja_JP.utf-8" > /etc/environment'
sudo localectl set-locale LANG=ja_JP.utf8

# firewall
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload


# rails
sudo curl -o /etc/yum.repos.d/public-yum-ol7.repo https://yum.oracle.com/public-yum-ol7.repo
sudo yum-config-manager --enable ol7_oracle_instantclient
sudo yum -y install oracle-instantclient18.3-basic oracle-instantclient18.3-devel oracle-instantclient18.3-sqlplus
sudo rm -rf /var/cache/yum
sudo sh -c 'echo /usr/lib/oracle/18.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient18.3.conf'
sudo ldconfig
echo 'export LD_LIBRARY_PATH="/usr/lib/oracle/18.3/client64/lib"' >> ~/.bash_profile
echo 'export TNS_ADMIN="/usr/local/etc"' >> ~/.bash_profile
echo 'export NLS_LANG="Japanese_Japan.AL32UTF8"' >> ~/.bash_profile
echo 'export PATH="/usr/lib/oracle/18.3/client64/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
sudo yum install -y git unzip vim gcc openssl-devel readline-devel zlib-devel sqlite-devel nodejs bzip2 make
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
mkdir -p ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
~/.rbenv/plugins/ruby-build/install.sh
git clone https://github.com/sstephenson/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
echo '# rbenv' >> ~/.bash_profile
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
rbenv install 2.6.3 -v
rbenv rehash
rbenv global 2.6.3
gem install -N rails ruby-oci8
rails new dummy && cd dummy && bundle package --all
cd

# laravel
sudo yum -y install libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel libXpm-devel freetype-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel gcc cmake git bzip2-devel libicu-devel gcc-c++ libzip libzip-devel autoconf automake
curl -L https://raw.githubusercontent.com/CHH/phpenv/master/bin/phpenv-install.sh | sh
echo 'export PATH="/home/opc/.phpenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(phpenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/php-build/php-build $HOME/.phpenv/plugins/php-build
PHP_BUILD_CONFIGURE_OPTS="--with-pear --with-oci8=shared,instantclient,/usr/lib/oracle/18.3/client64/lib" PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j4 phpenv install 7.1.29
phpenv global 7.1.29
phpenv rehash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
echo 'export PATH="/home/opc/.config/composer/vendor/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
composer global require laravel/installer
composer global require yajra/laravel-oci8:v5.8
composer create-project --prefer-dist "laravel/laravel=5.8.16" demo
pecl install oci8 <<<''
echo "extension=oci8.so" >> /home/opc/.phpenv/versions/7.1.29/etc/php.ini
composer require yajra/laravel-oci8:v5.8

# django
sudo yum -y install gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel git
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
pyenv install 3.6.7
pyenv global 3.6.7
pyenv rehash
pip install --upgrade pip
pip install django
pip install cx_oracle

# spring-boot
sudo yum -y install java-11-openjdk-devel
sudo yum -y install maven
sudo alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.3.7-0.0.1.el7_6.x86_64/bin/java
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"' >> ~/.bash_profile
source ~/.bash_profile
sudo wget http://central.maven.org/maven2/org/apache/maven/wagon/wagon-http/2.8/wagon-http-2.8-shaded.jar -P /usr/share/maven/lib/ext/

