#!/usr/bin/env bash
set -euo pipefail

OWNER="barhaim27-a11y"
NODE_IMAGE="ghcr.io/${OWNER}/super-app-node:latest"
PHP_IMAGE="ghcr.io/${OWNER}/super-app-php:latest"

echo "[1/6] Creating docker network"
docker network create superapp || true

echo "[2/6] Pulling images"
docker pull "$NODE_IMAGE"
docker pull "$PHP_IMAGE"
docker pull mysql:8.0

echo "[3/6] Stopping old containers (if any)"
docker rm -f superapp-node superapp-php superapp-mysql || true

echo "[4/6] Starting MySQL"
docker run -d --name superapp-mysql --network superapp \
  -e MYSQL_DATABASE=super_app \
  -e MYSQL_ROOT_PASSWORD=password \
  -p 3306:3306 \
  mysql:8.0

echo "[5/6] Starting Node"
docker run -d --name superapp-node --network superapp \
  -e DB_HOST=superapp-mysql \
  -e DB_PORT=3306 \
  -e DB_NAME=super_app \
  -e DB_USER=root \
  -e DB_PASSWORD=password \
  -p 3000:3000 \
  "$NODE_IMAGE"

echo "[6/6] Starting PHP (Apache)"
docker run -d --name superapp-php --network superapp \
  -e DB_HOST=superapp-mysql \
  -e DB_PORT=3306 \
  -e DB_NAME=super_app \
  -e DB_USER=root \
  -e DB_PASSWORD=password \
  -p 80:80 \
  "$PHP_IMAGE"

echo "Done. Open: http://<EC2-PUBLIC-IP>/  and  http://<EC2-PUBLIC-IP>:3000/"
