#!/bin/bash
mkdir .ssh
echo $BU_HOST_1 > .ssh/known_hosts
echo $BU_HOST_2 >> .ssh/known_hosts
echo $BU_PUBLIC > .ssh/id_rsa.pub
echo "-----BEGIN RSA PRIVATE KEY-----" > .ssh/id_rsa
echo $BU_PRIVATE_1 >> .ssh/id_rsa
echo $BU_PRIVATE_2 >> .ssh/id_rsa
echo $BU_PRIVATE_3 >> .ssh/id_rsa
echo $BU_PRIVATE_4 >> .ssh/id_rsa
echo $BU_PRIVATE_5 >> .ssh/id_rsa
echo $BU_PRIVATE_6 >> .ssh/id_rsa
echo $BU_PRIVATE_7 >> .ssh/id_rsa
echo $BU_PRIVATE_8 >> .ssh/id_rsa
echo $BU_PRIVATE_9 >> .ssh/id_rsa
echo $BU_PRIVATE_10 >> .ssh/id_rsa
echo $BU_PRIVATE_11 >> .ssh/id_rsa
echo $BU_PRIVATE_12 >> .ssh/id_rsa
echo $BU_PRIVATE_13 >> .ssh/id_rsa
echo $BU_PRIVATE_14 >> .ssh/id_rsa
echo $BU_PRIVATE_15 >> .ssh/id_rsa
echo $BU_PRIVATE_16 >> .ssh/id_rsa
echo $BU_PRIVATE_17 >> .ssh/id_rsa
echo $BU_PRIVATE_18 >> .ssh/id_rsa
echo $BU_PRIVATE_19 >> .ssh/id_rsa
echo $BU_PRIVATE_20 >> .ssh/id_rsa
echo $BU_PRIVATE_21 >> .ssh/id_rsa
echo $BU_PRIVATE_22 >> .ssh/id_rsa
echo $BU_PRIVATE_23 >> .ssh/id_rsa
echo $BU_PRIVATE_24 >> .ssh/id_rsa
echo $BU_PRIVATE_25 >> .ssh/id_rsa
echo "-----END RSA PRIVATE KEY-----" >> .ssh/id_rsa
/app/vendor/heroku-toolbelt/bin/heroku pg:backups capture --app clarat
export CURRENT_TIME=`date +"%Y-%m-%d-%H-%M-%S"`
curl -o /tmp/clarat-$CURRENT_TIME.dump `/app/vendor/heroku-toolbelt/bin/heroku pg:backups public-url --app clarat`
sftp -o "IdentityFile=/app/.ssh/id_rsa" backups@$SFTP_IP:backups <<COMMAND
  put /tmp/clarat-$CURRENT_TIME.dump
  quit
COMMAND
