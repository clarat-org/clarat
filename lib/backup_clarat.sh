#!/bin/bash
/app/vendor/heroku-toolbelt/bin/heroku pg:backups capture --app clarat
export CURRENT_TIME=`date +"%Y-%m-%d-%H-%M-%S"`
curl -o /tmp/clarat-$CURRENT_TIME.dump `/app/vendor/heroku-toolbelt/bin/heroku pg:backups public-url --app clarat`
sftp -o "IdentityFile=/app/.ssh/id_rsa" backups@$SFTP_IP:backups <<COMMAND
  put /tmp/clarat-$CURRENT_TIME.dump
  quit
COMMAND
