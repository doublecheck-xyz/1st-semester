echo "Configuring backup of servers in the project"
for ip in $(nova list | grep $1 | cut -f7 -d "|" | cut -f2 -d "="); do echo "$ip:/etc,/home" >> $1_backup.conf; done
echo "#!/bin/sh" > $1-backup
echo "/usr/bin/pull_backup.pl -c /home/ubuntu/$1_backup.conf" >> $1-backup 
chmod 777 $1-backup
scp $1_backup.conf ubuntu@10.1.2.66:.
scp $1-backup ubuntu@10.1.2.66:/etc/cron.hourly/
