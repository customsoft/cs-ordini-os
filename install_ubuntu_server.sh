#!/bin/bash

# Questo script automatizza la configurazione di un nuovo server, 
# incluso l'utente, il dominio, l'autenticazione a due fattori e 
# altro ancora.

# Si prega di utilizzare con attenzione e di verificare attentamente 
# le variabili e le impostazioni prima dell'esecuzione.

# ATTENZIONE: Assicurati che tutte le variabili siano state definite
# correttamente prima di eseguire questo script.
# Un uso improprio può causare danni al sistema.


# sudo su
# apt -y install wget

# Richiedi all'utente di inserire l'indirizzo IP del server.
# IP_SERVER=77.81.230.207
echo "IP_SERVER - esempio = 192.168.11.3:"; read IP_SERVER
# DOMINIO=u001.marcozordan.it
echo "Dominio/hostname - esempio = maria01.customsofts.it:"; read DOMINIO
# DOMAIN_USER=u001
echo "Nome utente dominio:"; read DOMAIN_USER;
echo "Password root:"; read -s ROOT_PASS;
# NEW_USER=marco
echo "Nome nuovo utente:"; read NEW_USER;
echo "Password nuovo utente:"; read -s NEW_USER_PASS;
echo "Email nuovo utente:"; read NEW_USER_EMAIL;
USER_BACKUP=bck
# echo "Nome utente BACKUP:"; read USER_BACKUP;
echo "Password utente BACKUP:"; read -s USER_BACKUP_PASS

echo ""

####################
# Imposto lingua
echo ""
echo -e " - Imposto LANG: \e[1mLANG=it_IT.UTF-8\e[0m";
#apt -y install language-support-it language-pack-it language-pack-gnome-it
apt -y install language-pack-it language-pack-gnome-it

mv /etc/default/locale /etc/default/locale.old
sed 's/LANG=C.UTF-8/LANG="it_IT.UTF-8"\nLANGUAGE="it_IT:it"/' </etc/default/locale.old >/etc/default/locale

export LANGUAGE=it_IT.UTF-8
export LANG=it_IT.UTF-8
export LC_ALL=it_IT.UTF-8
locale-gen it_IT.UTF-8
dpkg-reconfigure locales

echo ""
echo -e " - Imposto la timezone \e[1mEurope/Rome\e[0m\n"
timedatectl status
timedatectl set-timezone "Europe/Rome"
timedatectl set-ntp true
timedatectl status

echo ""

# Aggiorno i repository del sistema operativo per ottenere gli ultimi pacchetti.
echo -e " - Aggiorno il sistema operativo all'ultima versione\n"
apt -y update; 
if [ $? -eq 0 ]; then
    echo "Aggiornamento dei repository completato con successo."
else
    echo "Errore durante l'aggiornamento dei repository."
fi
apt -y upgrade
if [ $? -eq 0 ]; then
    echo "Miglioramento del sistema completato con successo."
else
    echo "Errore durante il miglioramento del sistema."
fi
apt -y autoremove 
if [ $? -eq 0 ]; then
    echo "Pulizia automatica completato con successo."
else
    echo "Errore durante la pulizia automatica."
fi
apt -y clean
if [ $? -eq 0 ]; then
    echo "Pulizia cache completato con successo."
else
    echo "Errore durante la pulizia cache."
fi


####################
# Verifica esistenza utente
getent passwd $NEW_USER > /dev/null

if [ $? -eq 0 ]; then
  echo "$NEW_USER esiste già."
else
  ####################
  # Creazione nuovo utente
  echo -e " - Creazione utente: \e[1m$NEW_USER\e[0m";
  echo -e "$NEW_USER_PASS\n$NEW_USER_PASS\n\n\n\n\n\n" | adduser $NEW_USER

  ####################
  # Impostazione nuovo utente
  echo -e " - Impostazione nuovo utente: \e[1m$NEW_USER\e[0m";
  echo -e "\n$NEW_USER  ALL=(ALL) ALL\n" >> /etc/sudoers
  mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
  #echo "PermitRootLogin no\nMaxAuthTries 3" >> /etc/ssh/sshd_config
  sed 's/PermitRootLogin yes/PermitRootLogin no\nMaxAuthTries 3/' </etc/ssh/sshd_config.old >/etc/ssh/sshd_config
  sed 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' </etc/ssh/sshd_config.old >/etc/ssh/sshd_config
  #sed 's/MaxAuthTries 6/MaxAuthTries 3/' </etc/ssh/sshd_config.old >/etc/ssh/sshd_config

  systemctl restart sshd
  chage -M 180 $NEW_USER
fi

####################
# Impostazione dominio
echo -e ""
echo -e " - Imposto dominio: \e[1m$DOMINIO\e[0m";
hostname $DOMINIO
echo -e "\n$IP_SERVER  $DOMINIO\n" >> /etc/hosts
# echo -e "HOSTNAME=$DOMINIO\n" >> /etc/sysconfig/network
hostnamectl set-hostname $DOMINIO

printf "root:  $NEW_USER_EMAIL\n$NEW_USER:  $NEW_USER_EMAIL\n" >> /etc/aliases
newaliases

echo -e ""
echo -e " - Attivo \e[1mautenticazione a 2 fattori\e[0m";
# Installa pacchetti per permettere l'autenticazione a 2 fattori
apt -y install libauthen-oath-perl
apt -y install openssl libpam-google-authenticator

echo -e "y\n-1\ny\ny\ny\ny\n\n" | sudo -u $NEW_USER google-authenticator | sendmail root "google authenticator" 
echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/common-session



# Installa pacchetti per permettere ad APT di utilizzare repository tramite HTTPS
apt install -y apt-transport-https ca-certificates curl software-properties-common

apt install -y docker-ce docker-ce-cli containerd.io

# Aggiungi il tuo utente al gruppo "docker" per eseguire Docker senza sudo
usermod -aG docker $USER

# Riavvia il servizio Docker
systemctl restart docker


# FINE SCRIPT
# Lo script è stato eseguito con successo. Ora il server è configurato con le impostazioni specificate.
# Assicurati di eseguire ulteriori test e verifiche per garantire che tutto funzioni correttamente.
# Per ulteriori informazioni, consulta la documentazione del sistema e del software utilizzato.
