# Crear archivo con tus datos
cat > arc-secrets.env << EOF
GITHUB_APP_ID=123456  # Tu App ID
GITHUB_APP_INSTALLATION_ID=987654  # Tu Installation ID
EOF

# Guardar private key
# Pega el contenido de tu private key en este archivo:
nano private-key.pem