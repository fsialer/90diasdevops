#!/bin/bash
set -e  # Detiene el script si algo falla
apt install -y nodejs
echo "Version node: "
node --version
