#!/bin/bash
################
# Script for creating Virtual Servers On Apache2
# Check for the correct parameters
if [ $# -lt 2 ]; then
	echo 'Você precisa passar o USER e o DOMÍNIO a ser criado'
	echo 'sh create-site user DOMAIN'
	echo ''
	echo 'Ex: sh create-site www gssolutions.com.br'
	echo 'Cria gssolutions.com.br em /var/www/gssolutions.com.br/public'
	exit 0
fi	

# Assign Variables
DOMAIN=$2
USER=$1

# Create the Directory which will contain your Virtual Site
if [ ! -d  /var/www/${DOMAIN} ]; then
	mkdir /var/www/${DOMAIN}
	echo 'create /var/www/${DOMAIN}'
fi
if [ ! -d  /var/www/${DOMAIN}/public ]; then
	mkdir /var/www/${DOMAIN}/public
	echo 'create /var/www/${DOMAIN}/public'
fi
if [ ! -d  /var/www/${DOMAIN}/logs ]; then
	mkdir /var/www/${DOMAIN}/logs
	echo 'create /var/www/${DOMAIN}/logs'
fi

chown -R ${USER}:${USER} /var/www/${DOMAIN}/public
chown -R ${USER}:${USER} /var/www/${DOMAIN}/logs

echo "<VirtualHost *:80>">> /etc/apache2/sites-available/${DOMAIN}

echo	"	ServerAdmin contato@gssolutions.com.br" >> /etc/apache2/sites-available/${DOMAIN}
echo	"	DocumentRoot \"/var/www/${DOMAIN}/public\"" >>/etc/apache2/sites-available/${DOMAIN}
echo	"	ServerName  ${DOMAIN}" >> /etc/apache2/sites-available/${DOMAIN}
echo	"	ServerAlias www.${DOMAIN}" >> /etc/apache2/sites-available/${DOMAIN}

echo 	"" >>/etc/apache2/sites-available/${DOMAIN}	

echo	'	<Directory />'>>/etc/apache2/sites-available/${DOMAIN}
echo	'		Options FollowSymLinks'>>/etc/apache2/sites-available/${DOMAIN}
echo	'		AllowOverride None'>>/etc/apache2/sites-available/${DOMAIN}
echo	'	</Directory>'>>/etc/apache2/sites-available/${DOMAIN}

echo 	"" >>/etc/apache2/sites-available/${DOMAIN}

echo	"	<Directory /var/www/${DOMAIN}/public>">>/etc/apache2/sites-available/${DOMAIN}
echo	'		Options Indexes FollowSymLinks MultiViews'>>/etc/apache2/sites-available/${DOMAIN}
echo	'		AllowOverride All'>>/etc/apache2/sites-available/${DOMAIN}
echo	'		Order allow,deny'>>/etc/apache2/sites-available/${DOMAIN}
echo	'		allow from all'>>/etc/apache2/sites-available/${DOMAIN}
echo	'	</Directory>'>>/etc/apache2/sites-available/${DOMAIN}

echo 	"" >>/etc/apache2/sites-available/${DOMAIN}

echo	"	ErrorLog /var/www/${DOMAIN}/logs/error.log">>/etc/apache2/sites-available/${DOMAIN}
echo	'	LogLevel warn'>>/etc/apache2/sites-available/${DOMAIN}
echo	"	CustomLog /var/www/${DOMAIN}/logs/access.log combined">>/etc/apache2/sites-available/${DOMAIN}
#echo	'	ServerSignature On'>>/etc/apache2/sites-available/${DOMAIN}

echo '</VirtualHost>'>>/etc/apache2/sites-available/${DOMAIN}

#create link to sites-enabled
if [ ! -L /etc/apache2/sites-enabled/${DOMAIN} ]; then 
	ln -s /etc/apache2/sites-available/${DOMAIN} /etc/apache2/sites-enabled/ 
fi

#Reload apache
sudo service apache2 reload