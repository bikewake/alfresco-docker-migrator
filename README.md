# Cleaning up Alfresco repository Tomcat log files
docker container cleaning log files periodically with cron logrotate added to Alfresco composer

## How to startup Alfresco with cron logrotate container

run to start up Alfresco instance:

    docker compose up --build -d 

Verify Tomcat log files:

    docker exec alfresco ls -l logs
or

    docker exec cron ls -l usr/local/tomcat/logs


and see growing log like this:

    $ docker exec alfresco ls -l logs
    total 2728
    -rw-r----- 1 alfresco alfresco   56968 Apr  1 08:35 alfresco.log
    -rw-r----- 1 alfresco alfresco   13070 Apr  1 08:34 catalina.2022-04-01.log
    -rw-r----- 1 alfresco alfresco       0 Apr  1 07:57 host-manager.2022-04-01.log
    -rw-r----- 1 alfresco alfresco     694 Apr  1 08:33 localhost.2022-04-01.log
    -rw-r----- 1 alfresco alfresco 2707432 Apr  1 10:08 localhost_access_log.2022-04-01.txt
    -rw-r----- 1 alfresco alfresco       0 Apr  1 07:57 manager.2022-04-01.log

localhost_access_log file could grow up to 7GB per day on development server used occasionally by few testers doing just few clicks per day.

Verify that cron is set

    docker exec cron crontab -l

Result job to run log clean up at 4 in the morning every day

    0 4 * * * root /usr/sbin/logrotate /etc/logrotate.d/alfresco

Verify logrotate configuration file

    docker exec cron cat  etc/logrotate.d/alfresco

Result, notice postrotate script delete files older than 4 days

    /usr/local/tomcat/logs/*.txt {
      su root root
      daily
      rotate 10
      compress
      copytruncate
      missingok
      nomail
      postrotate
        /usr/bin/find /usr/local/tomcat/logs/ -mtime +4 -name alfresco.log.\* -delete
        /usr/bin/find /usr/local/tomcat/logs/ -mtime +4 -name \*.gz\* -delete
        /usr/bin/find /usr/local/tomcat/logs/ -mtime +4 -name \*.txt\* -delete
        /usr/bin/find /usr/local/tomcat/logs/ -mtime +4 -name \*.log\* -delete
      endscript
      dateext
      size 50M
    }


force logrotate to run immediately for testing purpose

    docker exec cron logrotate -f etc/logrotate.d/alfresco

see compressed log result

    $ docker exec cron ls -l usr/local/tomcat/logs
    total 364
    -rw-r----- 1 33000 33000 225363 Apr  1 13:35 alfresco.log
    -rw-r----- 1 33000 33000  46406 Apr  1 13:34 catalina.2022-04-01.log
    -rw-r----- 1 33000 33000      0 Apr  1 09:57 host-manager.2022-04-01.log
    -rw-r----- 1 33000 33000   2627 Apr  1 13:33 localhost.2022-04-01.log
    -rw-r----- 1 33000 33000   3471 Apr  1 13:42 localhost_access_log.2022-04-01.txt
    -rw-r----- 1 33000 33000  74764 Apr  1 13:42 localhost_access_log.2022-04-01.txt-20220401.gz
    -rw-r----- 1 33000 33000      0 Apr  1 09:57 manager.2022-04-01.log

shutdown with

    docker compose down

