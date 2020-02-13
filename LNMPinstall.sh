#!/bin/bash
menu(){
clear
echo "###############----Menu----###############"
echo "# 1. Install Nginx"
echo "# 2. Install MySQL"
echo "# 3. Install PHP"
echo "# 4. Exit Program"
echo "##########################################"
}

choice(){
read -p "Please choice a menu[1-4]:" select
}

install_nginx(){
yum -y install gcc pcre-devel openssl-devel zlib-devel make
id nginx &>/dev/null
if [ $? -ne 0 ];then
  useradd -s /sbin/nologin nginx
fi
if [ -f nginx-1.8.0.tar.gz ];then
  tar -xf nginx-1.8.0.tar.gz
  cd nginx-1.8.0
  ./configure --prefix=/usr/local/nginx --with-http_ssl_module
  make && make install
  ln -s /usr/local/nginx/sbin/nginx /usr/sbin/
  cd ..
else
  echo "没有Nginx源码包"
  exit
fi
}

install_mysql(){
yum -y install gcc gcc-c++ cmake ncurses-devel perl
id mysql &>/dev/null
if [ $? -ne 0 ];then
  useradd -s /sbin/nologin mysql
fi
if [ -f mysql-5.6.25.tar.gz ];then
  tar -xf mysql-5.6.25.tar.gz
  cd mysql-5.6.25
  cmake .
  make && make install
  /usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/data/ --basedir=/usr/local/mysql/
  chown -R root.mysql /usr/local/mysql
  chown -R mysql /usr/local/mysql/data
  cp -f /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
  chmod +x /etc/init.d/mysqld
  cp -f /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
  echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf
  ldconfig
  echo 'PATH=\$PATH:/usr/local/mysql/bin/' >> /etc/profile
  export PATH
  cd ..
else
  echo "没有mysql源码包"
  exit
fi
}

install_php(){
yum -y install gcc libxml2-devel
if [ -f mhash-0.9.9.9.tar.gz ];then
  tar -xf mhash-0.9.9.9.tar.gz
  cd mhash-0.9.9.9
  ./configure
  make && make install
  cd ..
    if [ ! -f /usr/lib/libmhash.so ];then
      ln -s /usr/local/lib/libmhash.so /usr/lib/
    fi
    ldconfig
else
  echo "没有mhash源码包"
  exit
fi

if [ -f libmcrypt-2.5.8.tar.gz ];then
  tar -xf libmcrypt-2.5.8.tar.gz
  cd libmcrypt-2.5.8
  ./configure
  make && make install
  cd ..
    if [ ! -f /usr/lib/libmcrypt.so ];then
      ln -s /usr/local/lib/libmcrypt.so /usr/lib/
    fi
    ldconfig
else
  echo "没有libmcrypt源码包"
  exit
fi

if [ -f php-5.4.24.tar.gz ];then
  tar -xf php-5.4.24.tar.gz
  cd php-5.4.24
  ./configure --prefix=/usr/local/php5 --with-mysql=/usr/local/mysql --enable-fpm --enable-mbstring --with-mcrypt --with-mhash --with-config-file-path=/usr/local/php5/etc --with-mysqli=/usr/local/mysql/bin/mysql_config
  make && make install
  cp -f php.ini-production /usr/local/php5/etc/php.ini
  cp -f /usr/local/php5/etc/php-fpm.conf.default /usr/local/php5/etc/php-fpm.conf
  cd ..
else
  echo "没有php源码包"
  exit
fi
}

while :
do
  menu
  choice
  case $select in
    1)
      install_nginx;;
    2)
      install_mysql;;
    3)
      install_php;;
    4)
      exit;;
    *)
      echo "没有该选项，请重新选择"
      continue
  esac
done
