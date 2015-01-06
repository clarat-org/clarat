#!/bin/bash
/app/vendor/heroku-toolbelt/bin/heroku pgbackups:capture --app clarat
export CURRENT_TIME=`date +"%Y-%m-%d-%H-%M-%S"`
curl -o /tmp/clarat-$CURRENT_TIME.dump `/app/vendor/heroku-toolbelt/bin/heroku pgbackups:url --app clarat`
sftp -oPort=22022 sftp@$SFTP_IP:Backup-DB <<COMMAND
  put /tmp/clarat-$CURRENT_TIME.dump
  quit
COMMAND
