#!/bin/bash
cd `dirname $0`
cd ..
heroku pgbackups:capture
curl -o clarat-`date +"%Y-%m-%d-%H-%M-%S"`.dump `heroku pgbackups:url`
