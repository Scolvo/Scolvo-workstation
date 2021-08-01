#!/bin/sh

USERS_AUTH_KEYS_FILE="/home/${IMPORT_USER}/.ssh/authorized_keys"

if test -z ${IMPORT_USER}
then
  echo "The IMPORT_USER environment variable is not specified!"
  exit 1
fi

if test -z ${PUBLIC_KEY_FILE_PATH}
then
  echo "The PUBLIC_KEY_FILE_PATH environment variable is not specified!"
  exit 1
fi


echo "Storing host keys..."
cd /etc/ssh
echo -e ${SSH_ED25519_KEY} > /etc/ssh/ssh_host_ed25519_key
chmod 0600 /etc/ssh/ssh_host_ed25519_key
cd



echo "Creating user..."
adduser -D -s /bin/false ${IMPORT_USER}
sed -i "s/${IMPORT_USER}:!/${IMPORT_USER}:*/" /etc/shadow

echo "Creating ${USERS_AUTH_KEYS_FILE} ..."
mkdir -p $(dirname ${USERS_AUTH_KEYS_FILE})
touch ${USERS_AUTH_KEYS_FILE}
chmod 600 ${USERS_AUTH_KEYS_FILE}
chown ${IMPORT_USER} ${USERS_AUTH_KEYS_FILE}

echo "Importing user's public key to ${USERS_AUTH_KEYS_FILE} ..."
cat $PUBLIC_KEY_FILE_PATH >> ${USERS_AUTH_KEYS_FILE}

echo "Reseting permissions on /import ..."
chown root:root /import
chmod 755 /import
mkdir -p /import/upload
mkdir -p /import/dev
chown ${IMPORT_USER}:${IMPORT_USER} /import/upload
chmod 777 -R /import/upload

echo "Starting sshd..."
/usr/sbin/sshd -p 2222

echo "Starting rsyslog..."
/usr/sbin/rsyslogd

while [ ! -f /var/log/messages ]
do
	echo "Waiting for /var/log/messages to appear..."
	sleep 1
done

tail -f /var/log/messages
