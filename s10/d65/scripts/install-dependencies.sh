# install-dependencies.sh
echo "📦 Instalando dependencias para monitoreo..."

# Python dependencies
pip3 install psutil matplotlib requests

# Instalar herramientas de sistema
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install htop iftop
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    sudo apt-get update
    sudo apt-get install -y htop iftop sysstat
fi

echo "✅ Dependencias instaladas"