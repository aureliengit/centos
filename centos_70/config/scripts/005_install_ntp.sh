#!/bin/bash

# 005_install_ntp_serv.sh

# JP antinoux - décembre 2014
CWD=$(pwd)

if [ $USER != "root" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	# NTP
  echo ":: Ouvrir le port du parefeu : 123 ::"
  sleep 3

  # Ouvrir le fichier firewall.sh
  vim /usr/local/sbin/firewall.sh

  # Enregistrer les nouvelles règles
  bash -c /usr/local/sbin/firewall.sh

  # Relancer le service iptables
  systemctl restart iptables.service

  echo "--------------------------"
  echo ":: Arrêt du service ntp ::"
  echo "--------------------------"
  systemctl stop ntpd.service
  
  echo ":: Mise à jour initiale de l'horloge ::"
  ntpdate fr.pool.ntp.org
 
  echo "--------------------------------------------"
  echo ":: Ajustement du fichier de configuration ::"
  echo "--------------------------------------------"
	touch /var/log/ntp.log
	chown ntp:ntp /var/log/ntp.log
	cp /etc/ntp.conf /etc/ntp.conf_old
	cat $CWD/../ntp/etc/ntp.conf > /etc/ntp.conf

  echo ":: activation et lancement du service ::"
  systemctl enable ntpd.service
  systemctl start ntpd.service
	
  echo "-----------------------------------------------"
  echo ":: Vérification des serveurs : taper ntpq -p ::"
  echo "-----------------------------------------------"


fi

exit 0

