#!/usr/bin/env bash
set -e

docker build -t php-swoole/php-swoole:latest .
docker push php-swoole/php-swoole:latest
