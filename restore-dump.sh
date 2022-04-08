#!/bin/sh

docker exec postgres psql -U alfresco -l

docker exec postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco -c \"\dt+\""

docker exec -i postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco " < backup/dump.sql

docker exec postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco -c \"\dt+\""

#docker exec postgres bin/bash -c "PGPASSWORD=alfresco psql --username alfresco alfresco -c \"SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';\""



