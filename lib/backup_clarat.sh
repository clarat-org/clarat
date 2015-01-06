#!/bin/bash
cd `dirname $0`
cd ..
/app/vendor/heroku-toolbelt/bin/heroku pgbackups:capture
export CURRENT_TIME=`date +"%Y-%m-%d-%H-%M-%S"`
curl -o /tmp/clarat-$CURRENT_TIME.dump `/app/vendor/heroku-toolbelt/bin/heroku pgbackups:url`
sftp -oPort=22022 sftp@$SFTP_IP:Backup-DB <<COMMAND
  put /tmp/clarat-$CURRENT_TIME.dump
  quit
COMMAND
