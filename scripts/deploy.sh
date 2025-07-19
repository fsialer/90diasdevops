#!/bin/bash
ENV=$1
echo "Desplegando $ENV"
touch ../.env
if [[ $ENV == "staging" ]] ; then
    cp ../.env.staging.example ../.env
    echo "🏗️ Build de imágenes Docker"
    docker compose -f ../docker-compose.staging.yml build
    docker compose -f ../docker-compose.staging.yml up -d
elif [[ $ENV == "production" ]]; then
    cp ../.env.prod.example ../.env
    echo "🏗️ Build de imágenes Docker"
    docker compose -f ../docker-compose.prod.yml build
    docker compose -f ../docker-compose.prod.yml up -d
else
    cp ../.env.example ../.env
    echo "🏗️ Build de imágenes Docker"
    docker compose -f ../docker-compose.yml build
    docker compose -f ../docker-compose.yml up -d
    docker compose -f ../docker-compose.yml logs
    docker compose -f ../docker-compose.yml down -v
fi


