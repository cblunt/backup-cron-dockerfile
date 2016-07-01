#!/bin/sh

/usr/local/bin/whenever --update-crontab -f /root/Backup/schedule.rb
touch /var/log/cron.log
crond
tail -f /var/log/cron.log
