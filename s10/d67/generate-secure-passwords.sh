#!/bin/bash
# generate-secure-passwords.sh - Passwords seguros sin pensar

# Función para generar password seguro
generate_password() {
    local length=${1:-16}
    openssl rand -base64 32 | head -c $length
    echo
}

# Función para password memorable pero seguro
generate_memorable_password() {
    # Palabras + números + símbolos
    local words=("Casa" "Perro" "Sol" "Mar" "Luna" "Rio" "Monte" "Verde")
    local numbers=$(shuf -i 100-999 -n 1)
    local symbols=("!" "@" "#" "$" "%" "&")
    
    local word1=${words[$RANDOM % ${#words[@]}]}
    local word2=${words[$RANDOM % ${#words[@]}]}
    local symbol=${symbols[$RANDOM % ${#symbols[@]}]}
    
    echo "${word1}${word2}${numbers}${symbol}"
}

# Generar passwords para diferentes servicios
echo "🔐 GENERADOR DE PASSWORDS SEGUROS"
echo "================================"

echo "🔑 Password Admin (16 chars): $(generate_password 16)"
echo "🔑 Password DB (20 chars): $(generate_password 20)" 
echo "🔑 Password API (12 chars): $(generate_password 12)"
echo "🔑 Password Memorable: $(generate_memorable_password)"

# Guardar en archivo seguro
echo "💾 Guardando passwords en archivo seguro..."
{
    echo "# Passwords generados - $(date)"
    echo "ADMIN_PASSWORD=$(generate_password 16)"
    echo "DATABASE_PASSWORD=$(generate_password 20)"
    echo "API_SECRET=$(generate_password 32)"
    echo "JWT_SECRET=$(generate_password 24)"
} > .env.secrets

# Proteger el archivo
chmod 600 .env.secrets
echo "✅ Passwords guardados en .env.secrets (solo tu usuario puede leerlo)"