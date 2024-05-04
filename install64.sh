#!/bin/bash
clear
function msg {
BRAN='\033[1;37m' && RED='\e[31m' && GREEN='\e[32m' && YELLOW='\e[33m'
BLUE='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && BLACK='\e[1m' && SEMCOR='\e[0m'
case $1 in
-ne) cor="${RED}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
-ama) cor="${YELLOW}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
-verm) cor="${YELLOW}${BLACK}[!] ${RED}" && echo -e "${cor}${2}${SEMCOR}" ;;
-azu) cor="${MAG}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
-verd) cor="${GREEN}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
-bra) cor="${RED}" && echo -ne "${cor}${2}${SEMCOR}" ;;
-nazu) cor="${COLOR[6]}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
-gri) cor="\e[5m\033[1;100m" && echo -ne "${cor}${2}${SEMCOR}" ;;
"-bar2" | "-bar") cor="${RED}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
esac
}
function fun_prog {
comando[0]="$1"
${comando[0]}  > /dev/null 2>&1 &
tput civis
echo -ne "\033[1;32m.\033[1;33m.\033[1;31m. \033[1;32m"
while [ -d /proc/$! ]
do
for i in / - \\ \|
do
sleep .1
echo -ne "\e[1D$i"
done
done
tput cnorm
echo -e "\e[1DOK"
sleep 1
}
function fun_bar {
comando="$1"
_=$(
$comando >/dev/null 2>&1
) &
>/dev/null
pid=$!
while [[ -d /proc/$pid ]]; do
echo -ne " \033[1;33m["
for ((i = 0; i < 20; i++)); do
echo -ne "\033[1;31m#"
sleep 0.5
done
echo -ne "\033[1;33m]"
sleep 1s
echo
tput cuu1
tput dl1
done
echo -e " \033[1;33m[\033[1;31m########################################\033[1;33m] - \033[1;32m100%\033[0m"
sleep 1s
}
function print_center {
if [[ -z $2 ]]; then
text="$1"
else
col="$1"
text="$2"
fi
while read line; do
unset space
x=$(((50 - ${#line}) / 2))
for ((i = 0; i < $x; i++)); do
space+=' '
done
space+="$line"
if [[ -z $2 ]]; then
msg -azu "$space"
else
msg "$col" "$space"
fi
done <<<$(echo -e "$text")
}
function title {
clear
msg -bar
if [[ -z $2 ]]; then
print_center -azu "$1"
else
print_center "$1" "$2"
fi
msg -bar
}
function title2 {
clear
msg -bar
if [[ -z $2 ]]; then
print_center -verm "$1"
else
print_center "$1" "$2"
fi
msg -bar
}
function stop_install {
[[ ! -e /bin/pweb ]]  && {
title2 "INSTALAÇÃO CANCELADA"
cat /dev/null > ~/.bash_history && history -c
rm install* > /dev/null 2>&1
exit;
} || {
title2 "INSTALAÇÃO CANCELADA"
cat /dev/null > ~/.bash_history && history -c
rm install* > /dev/null 2>&1
exit;
}
}
function os_system {
system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/	  //')
distro=$(echo "$system" | awk '{print $1}')
case $distro in
Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
esac
}
function dependencias {
apt install apache2 -y > /dev/null 2>&1
add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
apt install dirmngr apt-transport-https -y > /dev/null 2>&1
soft="python bc screen at nano unzip lsof net-tools dos2unix nload python3 php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-mcrypt php7.4-xml php7.4-curl php7.4-ssh2 php7.4-mbstring php7.4-cli php7.4-common php7.4-xmlrpc php7.4-gd php7.4-imagick php7.4-dev php7.4-imap php7.4-opcache php7.4-soap php7.4-zip php7.4-intl"
for i in $soft; do
leng="${#i}"
puntos=$((21 - $leng))
pts="."
for ((a = 0; a < $puntos; a++)); do
pts+="."
done
msg -nazu "	   INSTALANDO $i$(msg -ama "$pts")"
if apt install $i -y &>/dev/null; then
msg -verd " INSTALADO"
else
msg -verm2 " ERRO"
sleep 2
tput cuu1 && tput dl1
print_center -ama "APLICANDO FIX A $i"
dpkg --configure -a &>/dev/null
sleep 2
tput cuu1 && tput dl1
msg -nazu "	   INSTALANDO $i$(msg -ama "$pts")"
if apt install $i -y &>/dev/null; then
msg -verd " INSTALADO"
else
msg -verm2 " ERRO"
fi
fi
done
}
function fun_att {
export DEBIAN_FRONTEND=noninteractive > /dev/null 2>&1
export DEBIAN_PRIORITY=critical > /dev/null 2>&1
apt -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade > /dev/null 2>&1
apt -qy update > /dev/null 2>&1
apt install software-properties-common -y > /dev/null 2>&1
add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
apt install figlet lolcat boxes gem curl cowsay jq -y > /dev/null 2>&1
apt -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade > /dev/null 2>&1
apt -qy update > /dev/null 2>&1
apt -qy autoremove > /dev/null 2>&1
apt -qy autoclean > /dev/null 2>&1
apt clean -y > /dev/null 2>&1
}
function install_start {
if [[ -e "/var/www/html/.htaccess" ]]; then
clear
msg -bar
echo -e "\033[1;31mPAINEL JÁ INSTALADO EM SUA VPS, RECOMENDO\033[0m"
echo -e "\033[1;31mUMA FORMATAÇÃO PARA UMA NOVA INSTALAÇÃO!\033[0m"
msg -bar
sleep 2
systemctl restart apache2 > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
exit;
else
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e 'by: @nandoslayer' >/usr/lib/telegram
echo ""
title "ATUALIZAÇÃO DO SISTEMA"
echo ""
print_center -ama " O SISTEMA SERÁ ATUALIZADO! PODE DEMORAR UM POUCO."
echo ""
msg -ne "\n VOCÊ DESEJA CONTINUAR? [S/n]: "
read opcion
[[ "$opcion" != @(s|S) ]] && stop_install
echo ""
title "ATUALIZAÇÃO DO SISTEMA"
echo ""
echo -ne "\033[1;33m[\033[1;31m ! \033[1;33m] \033[1;34mATUALIZANDO SISTEMA "; fun_prog 'fun_att'
echo ""
echo -ne "\033[1;33m[\033[1;31m ! \033[1;33m] \033[1;34mFINALIZANDO "; fun_prog 'fun_att'
echo ""
echo -ne "\033[1;33m[\033[1;31m ! \033[1;33m] \033[1;34mCONCLUINDO "; fun_prog 'fun_att'
echo ""
print_center "\033[1;33m • \033[1;32mATUALIZAÇÃO CONCLUÍDA COM SUCESSO\033[1;33m • \033[0m"
echo ""
sleep 2
install_continue
fi
}
function install_continue {
msg -bar
echo -e "\e[5m\033[1;100m           CONCLUINDO PACOTES PARA O SCRIPT         \033[0m"
msg -bar
print_center -ama "$distro $vercion"
print_center -verd "INSTALANDO DEPENDÊNCIAS"
msg -bar3
dependencias
msg -bar3
print_center -azu "REMOVENDO PACOTES OBSOLETOS"
apt autoremove -y &>/dev/null
sleep 2
tput cuu1 && tput dl1
msg -bar
print_center -ama "SE ALGUMAS DAS DEPENDÊNCIAS FALHAREM!!!\nQUANDO TERMINAR, VOCÊ PODE TENTAR INSTALAR\nO MESMO MANUALMENTE USANDO O SEGUINTE COMANDO\napt install nome_do_pacote"
msg -bar
read -t 10 -n 1 -rsp $'\033[1;39m		<< PRESSIONE ENTER PARA CONTINUAR >>		\n\033[0m'
clear
[[ $(grep -c "prohibit-password" /etc/ssh/sshd_config) != '0' ]] && {
sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "without-password" /etc/ssh/sshd_config) != '0' ]] && {
sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PermitRootLogin" /etc/ssh/sshd_config) != '0' ]] && {
sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication" /etc/ssh/sshd_config) = '0' ]] && {
echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
[[ $(grep -c "#PasswordAuthentication no" /etc/ssh/sshd_config) != '0' ]] && {
sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
} > /dev/null
echo ""
figlet -f slant GESTOR-GERAL | boxes -d cat -pa2t0b0 | lolcat -a -d 2
echo -e "\033[1;32m				                      By\033[1;36m NTECH SYSTEM\033[0m"
echo ""
echo -e "\033[1;36mDEFINA UMA NOVA SENHA PARA\033[0m"
echo -e "\033[1;36mO USUÁRIO ROOT DA VPS E\033[0m"
echo -e "\033[1;36mPARA O USUÁRIO DO PHPMYADMIN!\033[0m"
echo ""
read -p "DIGITE UMA NOVA SENHA ROOT: " passdb
echo "root:$passdb" | chpasswd
echo -e "\n\033[1;36mINICIANDO INSTALAÇÃO \033[1;33mAGUARDE...\033[0m"
sleep 2
install_continue2
}
function install_geral {
tar xzvf /root/gestorsite.tar.gz -C / >/dev/null 2>&1
chmod 777 -R /opt/gestorarquivos
mv /opt/gestorarquivos/atlas /bin/atlas > /dev/null 2>&1
rm /root/gestorsite.tar.gz > /dev/null 2>&1
chmod 777 -R /bin/atlas
[[ ! -e /etc/autostart ]] && {
echo '#!/bin/bash
clear
#INICIO AUTOMATICO' >/etc/autostart
chmod +x /etc/autostart
}
}
function install_continue2 {
clear
echo ""
echo -ne "\033[1;33m[\033[1;31m ! \033[1;33m] \033[1;31mINSTALANDO\033[0m"; fun_prog 'install_geral'
echo ""
echo -ne "\033[1;33m[\033[1;31m ! \033[1;33m] \033[1;31mCONCLUINDO\033[0m"; fun_prog 'sleep 2'
echo ""
print_center "\033[1;33m • \033[1;32mARQUIVOS INSTALADO COM SUCESSO\033[1;33m • \033[0m"
echo ""
sleep 2
inst_base
}
function inst_base {
clear
echo -e "\n\033[1;36mINSTALANDO O APACHE2 \033[1;33mAGUARDE...\033[0m"
sleep 2
apt install mariadb-server -y > /dev/null 2>&1
[[ ! -d /var/www/html ]] && mkdir /var/www/html
systemctl restart apache2 > /dev/null 2>&1
echo -e "\n\033[1;36mINSTALANDO O MySQL \033[1;33mAGUARDE...\033[0m"
mysqladmin -u root password "$passdb"
mysql -u root -p"$passdb" -e "UPDATE mysql.user SET Password=PASSWORD('$passdb') WHERE User='root'"
mysql -u root -p"$passdb" -e "FLUSH PRIVILEGES"
mysql -u root -p"$passdb" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$passdb" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$passdb" -e "FLUSH PRIVILEGES"
echo '# GESTOR_GERAL
[client]
port                            = 3306
[mysqld_safe]
nice                            = 0
[mysqld]
user                            = mysql
port                            = 3306
basedir                         = /usr
datadir                         = /var/lib/mysql
tmpdir                          = /tmp
lc-messages-dir                 = /usr/share/mysql
skip-external-locking
skip-name-resolve
bind-address                    = *
key_buffer_size                 = 128M
myisam_sort_buffer_size         = 4M
max_allowed_packet              = 64M
myisam-recover-options          = BACKUP
max_length_for_sort_data        = 8192
query_cache_limit               = 0
query_cache_size                = 0
query_cache_type                = 0
expire_logs_days                = 10
max_binlog_size                 = 100M
max_connections                 = 8192
back_log                        = 4096
open_files_limit                = 20240
innodb_open_files               = 20240
max_connect_errors              = 3072
table_open_cache                = 4096
table_definition_cache          = 4096
tmp_table_size                  = 1G
max_heap_table_size             = 1G
innodb_buffer_pool_size         = 10G
innodb_buffer_pool_instances    = 10
innodb_read_io_threads          = 64
innodb_write_io_threads         = 64
innodb_thread_concurrency       = 0
innodb_flush_log_at_trx_commit  = 0
innodb_flush_method             = O_DIRECT
performance_schema              = 0
innodb-file-per-table           = 1
innodb_io_capacity              = 20000
innodb_table_locks              = 0
innodb_lock_wait_timeout        = 0
sql_mode                        = "NO_ENGINE_SUBSTITUTION"
[mariadb]
thread_cache_size               = 8192
thread_handling                 = pool-of-threads
thread_pool_size                = 12
thread_pool_idle_timeout        = 20
thread_pool_max_threads         = 1024
[mysqldump]
quick
quote-names
max_allowed_packet              = 16M
[mysql]
[isamchk]
key_buffer_size                 = 16M' >> /etc/mysql/my.cnf
phpenmod mcrypt > /dev/null 2>&1
a2enmod rewrite > /dev/null 2>&1
a2enmod ssl > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
make-ssl-cert generate-default-snakeoil --force-overwrite > /dev/null 2>&1
a2ensite default-ssl > /dev/null 2>&1
service apache2 reload > /dev/null 2>&1
php -m | grep ssh2 > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
chmod +x /usr/local/bin/composer > /dev/null 2>&1
cd /var/www/html || exit
rm index.html > /dev/null 2>&1
systemctl restart mysql > /dev/null 2>&1
cd || exit
mv /opt/gestorarquivos/.htaccess /var/www/html > /dev/null 2>&1
phpmadm
}
function phpmadm {
cd /usr/share || exit
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
unzip phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
mv phpMyAdmin-5.2.0-all-languages phpmyadmin > /dev/null 2>&1
ln -s /usr/share/phpmyadmin /var/www/html/phpgeral > /dev/null 2>&1
systemctl restart apache2 > /dev/null 2>&1
rm phpMyAdmin-5.2.0-all-languages.zip > /dev/null 2>&1
cd || exit
chmod 777 -R /var/www/html > /dev/null 2>&1
chmod 777 -R /usr/share/phpmyadmin > /dev/null 2>&1
cron_set
}
function cron_set {
crontab -l > cronset > /dev/null 2>&1
echo "@reboot bash /etc/autostart
2 */1 * * * bash /opt/gestorarquivos/cron_back_geral" > cronset
crontab cronset && rm cronset > /dev/null 2>&1
service cron restart > /dev/null 2>&1
fun_swap
}
function fun_swap {
swapoff -a
rm -rf /bin/ram.img > /dev/null 2>&1
fallocate -l 1G /bin/ram.img > /dev/null 2>&1
chmod 600 /bin/ram.img > /dev/null 2>&1
mkswap /bin/ram.img > /dev/null 2>&1
swapon /bin/ram.img > /dev/null 2>&1
echo 50	 > /proc/sys/vm/swappiness
echo '/bin/ram.img none swap sw 0 0' | tee -a /etc/fstab > /dev/null 2>&1
sleep 2
finalizar
}
function finalizar {
clear
IP=$(wget -qO- ipv4.icanhazip.com)
echo $passdb > /opt/gestorarquivos/sweb
sed -i "s;upload_max_filesize = 2M;upload_max_filesize = 512M;g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s;post_max_size = 8M;post_max_size = 256M;g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s;memory_limit = 128M;memory_limit = 512M;g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s/;opcache.enable_cli=0/opcache.enable_cli=1/g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=120/g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s/;opcache.memory_consumption=128/opcache.memory_consumption=256/g" /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf > /dev/null 2>&1
update-alternatives --set php /usr/bin/php7.4
sleep 1
systemctl restart apache2 > /dev/null 2>&1
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
echo ""
figlet -f slant GESTOR-GERAL | boxes -d cat -pa2t0b0 | lolcat -a -d 2
echo -e "\033[1;32m				                      By\033[1;36m NTECH SYSTEM\033[0m"
echo ""
echo -e "\033[1;32mPAINEL INSTALADO COM SUCESSO!\033[0m"
echo ""
print_center "\033[1;33m[\033[1;31m ! \033[1;33m]\033[0m O TEMPO DE INSTALAÇÃO DO SCRIPT NO \n\033[1;36m$distro $vercion\033[0m FOI DE \033[1;33m$((($(date +%s)-$TIME_START)/60)) MINUTOS.\033[0m"
echo ""
echo -e "\033[1;36m PHPMYADMIN:\033[1;37m http://$IP/phpgeral\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m root\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m $passdb\033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mCOMANDO PRINCIPAL: \033[1;32matlas\033[0m"
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@paineis\033[0m"
echo ""
echo -ne "\n\033[1;31mENTER \033[1;33mpara entrar no atlas...\033[1;32m! \033[0m"; read
rm install* > /dev/null 2>&1
atlas
clear
exit;
}
os_system
[[ "$(whoami)" != "root" ]] && {
sleep 1s
echo -e "\033[1;33m[\033[1;31mERRO\033[1;33m] \033[1;37m- \033[1;33mVOCÊ PRECISA EXECUTAR COMO ROOT\033[0m"
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1; exit 0
}
if [[ "$distro" != "Ubuntu" ]]; then
sleep 1s
echo -e "\n\033[1;31mSISTEMA NÃO COMPATIVEL! FAVOR\nINSTALAR O UBUNTU 20.04!\033[0m"
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1; exit 0
else
if [[ "$vercion" == "20.04" ]]; then
TIME_START="$(date +%s)"
install_start
else
sleep 1s
echo -e "\n\033[1;31mSISTEMA NÃO COMPATIVEL! FAVOR\nINSTALAR O UBUNTU 20.04!\033[0m"
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1; exit 0
fi
fi
