# Cleaning up Alfresco repository Tomcat log files
docker container cleaning log files periodically with cron logrotate added to Alfresco composer

## How to startup Alfresco with cron logrotate container

`docker compose up -d` will start up Alfresco instance. Type:

    docker exec alfresco ls -l logs

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


### Created by www.bikefresco.com
