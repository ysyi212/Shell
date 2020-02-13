#!/bin/bash

read -p "请输入您的装机服务器:" ip
read -p "请输入您想要的ip最小值（1-255）：" min
read -p "请输入您想要的ip最大值（1-255）,必须比最小值小：" max
read -p "请输入您的yum源："  yum_source

sub_ip="${ip%.*}"   # 从右边开始删除第一个.及其右边的数据
tftp=/var/lib/tftpboot/

# 创建yum仓库
cat >/etc/yum.repo.s/my_yum.repo <<EOF
[development]
name=my_yum
baseurl=$yum_source
enabled=1
gpgcheck=0
EOF


# 安装 httpd dhcp tftp-server syslinux 
yum -y install httpd syslinux tftp-server dhcp >/dev/null 2>/var/log/pxe.error

# 配置镜像文件
if [ ! -d /var/www/html/rhel7  ];then
  mkdir /var/www/html/rhel7       
fi   
mount /dev/cdrom /var/www/html/rhel7 > /dev/null 2>/var/log.pxe.error

# 配置资源文件 
if [ ! -d /menu  ];then
  mkdir /menu       
fi   
mount /dev/cdrom /menu >/dev/null 2>/var/log.pxe.error 

# 配置DHCP     
cat >/etc/dhcp/dhcpd.conf <<EOF
subnet ${sub_ip}.0 netmask 255.255.255.0 {
  range ${sub_ip}.${min} ${sub_ip}.${max};
  option domain-name-servers $ip;
  option routers ${sub_ip}.254;
  default-lease-time 600;
  max-lease-time 7200;
  next-server $ip;
  filename "pxelinux.0";
}
EOF

# 配置相关资源
if [ -d ${tftp}pxelinux.cfg ];then
  rm -rf  ${tftp}pxelinux.cfg
fi
mkdir ${tftp}pxelinux.cfg/                # 创建菜单文件
cp /usr/share/syslinux/pxelinux.0 $tftp   # 网卡引导文件
cp /menu/isolinux/vesamenu.c32 $tftp      # 部署图形模块
cp /menu/isolinux/splash.png $tftp        # 部署背景图片
cp /menu/isolinux/vmlinuz $tftp           # 部署内核
cp /menu/isolinux/initrd.img $tftp        # 部署驱动


# 装机基本设置
cat >/var/www/html/ks.cfg <<EOF
#platform=x86, AMD64, 或 Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
# perl -e 'print crypt("a",q($1$a)),"\n"'
rootpw --iscrypted $1$a$44cUw6Nm5bX0muHWNIwub0
# Use network installation
url --url="http://$ip/rhel7"
# System language
lang zh_CN
# Firewall configuration
firewall --disabled
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use graphical install
graphical
firstboot --disable
# SELinux configuration
selinux --disabled

# Network information
network  --bootproto=dhcp --device=eth0
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part swap --fstype="swap" --size=1024
part /boot --fstype="xfs" --size=250
part / --fstype="xfs" --grow --size=1

%post --interpreter=/bin/bash
useradd lily
echo 'redhat' | passwd --stdin lily
%end

%packages
@base

-abrt-addon-ccpp
-abrt-addon-python
-abrt-cli
-abrt-console-notification
-bash-completion
-blktrace
-bridge-utils
-bzip2
-chrony
-cryptsetup
-dmraid
-dosfstools
-ethtool
-fprintd-pam
-gnupg2
-hunspell
-hunspell-en
-kpatch
-ledmon
-libaio
-libreport-plugin-mailx
-libstoragemgmt
-lvm2
-man-pages
-man-pages-overrides
-mdadm
-mlocate
-mtr
-nano
-ntpdate
-pinfo
-plymouth
-pm-utils
-rdate
-rfkill
-rng-tools
-rsync
-scl-utils
-setuptool
-smartmontools
-sos
-sssd-client
-strace
-sysstat
-systemtap-runtime
-tcpdump
-tcsh
-teamd
-time
-unzip
-usbutils
-vim-enhanced
-virt-what
-wget
-which
-words
-xfsdump
-xz
-yum-langpacks
-yum-utils
-zip


%end
EOF

# 菜单设置
cat >${tftp}/pxelinux.cfg/default <<EOF
default vesamenu.c32
timeout 60
#display boot.msg    
prompt vesamenu.c32

label linux
  menu label ^Install RHEL7
  menu default
  kernel vmlinuz
  append initrd=initrd.img ks=http://$ip/ks.cfg
EOF

#启动服务
systemctl restart dhcpd  
systemctl restart tftp
systemctl restart httpd

echo "pxe服务端部署完成!"
