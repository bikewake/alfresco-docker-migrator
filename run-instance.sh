#!/bin/sh

getComposeFileFromServiceName() {
  echo "${PWD}/$1/docker-compose.yml"
}

doDockerComposeUp() {
  SERVICE_DOCKER_FILE_NAME=$(getComposeFileFromServiceName "$1")
  docker compose -f "$SERVICE_DOCKER_FILE_NAME" --project-name "$1" --env-file ${PWD}/"$1"/.env up -d
}

doDockerCompose() {
  SERVICE_DOCKER_FILE_NAME=$(getComposeFileFromServiceName "$2")
  docker compose -f "$SERVICE_DOCKER_FILE_NAME" --project-name "$2" --env-file ${PWD}/"$2"/.env "$1"
}

start() {
  docker volume create alfresco-migrator-ass-volume
}

purge() {
  docker volume rm -f alfresco-migrator-ass-volume
}

case "$1" in
up)
  start
  doDockerComposeUp "instance"
  ;;
down)
  doDockerCompose "down" "instance"
  ;;
purge)
  doDockerCompose "down" "instance"
  purge
  ;;
*)
  echo "Usage: $0 {up|down|purge}"
  ;;
esac
