# INSTALACION
brew install aquasecurity/trivy/trivy
# o directamente
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
choco install trivy #Windows

# ESCANEAR IMAGEN
# Escaneo completo de vulnerabilidades en una imagen
trivy image feralexis007/vote-front:c80c12880336a8fa528c50edb2a7eefcd52f4766
# Salida como JSON
trivy image -f json -o resultado.json feralexis007/vote-front:c80c12880336a8fa528c50edb2a7eefcd52f4766
# Salida como tabla Markdown
trivy image -f table feralexis007/vote-front:c80c12880336a8fa528c50edb2a7eefcd52f4766
# Escanear dependencias de una app local
trivy fs .