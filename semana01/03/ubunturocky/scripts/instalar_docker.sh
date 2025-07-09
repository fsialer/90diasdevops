#!/bin/bash
set -e  # Detiene el script si algo falla
apt update
apt install -y docker.io
systemctl enable --now docker
docker --version
