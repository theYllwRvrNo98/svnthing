仓库备份到 /data-backup/svn-backup

增量备份:  每30次有效备份  全量备份一次 然后增量备份


定时任务
flock -xn 如果上个任务未完成 下个任务自动放弃

1 0 * * * flock -xn /data-svn/svn-backup/backup.lock  /bin/bash /data-svn/svn-backup/backup.sh >> /var/log/svnbackup.log 2>&1

一个svn web管理界面
https://gitee.com/cym1102/svnWebUI





