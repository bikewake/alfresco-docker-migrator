
# Backup and restore Alfresco from Docker Instance

### Based on Alfresco docker deployment with build tools: Docker, GitBash

First start Maria Db, Activemq, with build of cron-logrotate-backup helping container with backup volume.

    ./first-base.sh up 

Start Alfresco Instance.

    ./run-instance.sh up

Open Alfresco in browser with url [http://localhost:8180/share/](http://localhost:8180/share/) user admin, password admin, spend a little time creating sites
uploading documents for later review of restored backup data.

Stop Alfresco with Ctrl-C and purge Solr volume data, Alfresco repository volume and Maria data volume are not purged.

    ./run-instance.sh purge

Run backup of Sql database and Alfresco data file repository, script will generate .sql and .gz in local file system outside of docker containers.

    ./sql-dump.sh  

Backup files are saved on local file system, now it is safe to purge all docker containers

    ./first-base.sh purge

Verify sql backup file is present in local file system

    ls -l *.sql

Verify repository backup file is present in local file system

    ls -l backup/*.gz

## Restore Backup steps

Start Maria DB and create volumes where backup data will be restored.

    ./first-base.sh up    

Verify Alfresco database exist.

    docker exec postgres psql -U alfresco -l

Verify Alfresco database is empty.

    docker exec postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco -c \"\dt+\""

Restore Alfresco Sql database

    ./restore-dump.sh

Verify Alfresco Sql tables are created

    docker exec postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco -c \"\dt+\""

Verify Alfresco data file system is empty

    docker exec cron ls -l usr/local/tomcat/alf_data

Restore Alfresco data from backup file

    ./data-restore.sh

Verify Alfresco data file system is not empty

    docker exec cron ls -l usr/local/tomcat/alf_data

Start Alfresco instance again

    ./run-instance.sh up

Open Alfresco [http://localhost:8180/share/](http://localhost:8180/share/) and verify backup data are restored.
