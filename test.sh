#!/bin/sh

docker-compose up -d 

mix test

docker-compose down -v
