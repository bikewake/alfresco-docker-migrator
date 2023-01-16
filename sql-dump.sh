#!/bin/sh
docker exec -i postgres bin/bash -c "PGPASSWORD=alfresco pg_dump --username alfresco alfresco" > dump-$(date +%F_%H-%M-%S).sql

docker exec cron tar -zcvpf usr/local/tomcat/backup/alf-backup-acs-$(date +%F_%H-%M-%S)-tar.gz usr/local/tomcat/alf_data

docker exec cron ls -l usr/local/tomcat/alf_data

docker cp cron:usr/local/tomcat/backup  .

