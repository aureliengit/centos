#!/bin/bash

# 007_dnsmasq.sh
# JP Antinoux - janvier 2015

#"""""""""""""""""""""""""""""""""""""""""""""""""""""""#
# Modifier les paramètres avant de lancer le script !!! #
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""#

CWD=$(pwd)

[ $USER != "root" ] ;
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	# Ouverture des ports du parefeu
        echo "--------------------------------------------------------"
        echo ":: Ouverture du parefeu tcp-udp : 53 - udp : 67 et 68 ::"
        echo "--------------------------------------------------------"
  # Ouvre le fichier firewall pour permettre les modifications      
        vim /usr/local/sbin/firewall.sh
        
  # Enregistre les modifications dans le parefeu      
        bash -c /usr/local/sbin/firewall.sh

  # Relance le service pour mettre à jour et figer les règles      
        systemctl restart iptables.service

        echo "------------------------------"
        echo ":: Configuration de dnsmasq ::"
        echo "------------------------------"
  # Ouvre le modèle de fichier dnsmasq.conf pour permettre les modifications      
        vim $CWD/../dnsmasq/dnsmasq.conf

  # Copie le fichier de configuration en "fichier.old"        
        cp /etc/dnsmasq.conf /etc/dnsmasq.conf.old

  # Envoie les données du modèle vers le fichier de configuration.      
        cat $CWD/../dnsmasq/dnsmasq.conf > /etc/dnsmasq.conf

        echo "------------------------------"
        echo ":: Activation de dnsmasq ::"
        echo "------------------------------"
        systemctl enable dnsmasq.service
        systemctl start dnsmasq.service

        echo "----------------------------------------"
        echo ":: Modifier manuellement les fichiers : "
        echo ":: /etc/hosts et /etc/resolv.conf :: "
        echo "----------------------------------------"
fi

exit 0
