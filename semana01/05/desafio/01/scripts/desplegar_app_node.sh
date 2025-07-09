#!/bin/bash

# Configuración
REPO_URL="https://github.com/roxsross/devops-static-web.git"  # Reemplaza por tu URL
BRANCH=ecommerce-ms
APP_DIR="devops-ecommerce"
LOG_FILE="LOG_FILEs_pm2.txt"
PATH_APP=${APP_DIR}

instalar_dependencias(){
    echo "🔧 Instalando dependencias" | tee -a $LOG_FILE
    echo "Actualizando paquetes" >> $LOG_FILE 2>&1
    apt update && apt upgrade -y
    if ! command -v node >/dev/null 2>&1; then
        echo "⌛Instalando nodejs ..." >> $LOG_FILE 2>&1
        apt install  nodejs
        echo "✅ Nodejs instalado"  >> $LOG_FILE 2>&1
    else
        echo "✅ Node.js se encuentra instalado: $(node -v)" >> $LOG_FILE 2>&1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "⌛Instalando npm ..."  >> $LOG_FILE 2>&1
        apt install -y npm
        echo "✅ Npm instalado ..." >> $LOG_FILE 2>&1
    else
        echo "✅ Npm se encuentra instalado: $(npm -v)" >> $LOG_FILE 2>&1
    fi

    if ! command -v pm2  >/dev/null 2>&1; then
        echo "⌛Instalando PM2 ..." >> $LOG_FILE 2>&1
        npm install -g pm2
        echo "✅ MP2 instalado ..."  >> $LOG_FILE 2>&1
    else
        echo "✅ MP2 se encuentra instalado: $(pm2 -v)"  >> $LOG_FILE 2>&1
    fi

    if ! command -v git  >/dev/null 2>&1; then
        echo "⌛Instalando git ..." >> $LOG_FILE 2>&1
        apt install -y git
        echo "✅ Git instalado." >> $LOG_FILE 2>&1
    else
        echo "✅ Git se encuentra instalado: $(git -v)"  >> $LOG_FILE 2>&1
    fi
}

clonar_repositorio(){
    echo "🔧 Instalando repositorio" | tee -a $LOG_FILE
    echo "⌛ Clonando repositorio $REPO_URL"  >> $LOG_FILE 2>&1
    git clone $REPO_URL $APP_DIR 
    git config --global --add safe.directory $APP_DIR
    echo "✅ Repositorio clonado correctamente."  >> $LOG_FILE 2>&1
    echo "✅ Ingresando a la ruta ${PATH_APP}"  >> $LOG_FILE 2>&1
    cd $PATH_APP
    echo "Cambiando de rama $BRANCH" >> ../$LOG_FILE 2>&1
    git checkout $BRANCH
    echo "Rama actual: $BRANCH"  >> ../$LOG_FILE 2>&1
}

instalar_paquetes(){
     echo "🔧 Instalando paquetes"  | tee -a ../$LOG_FILE
     echo "⌛ Instalando paquetes de  frontend..."  >> ../$LOG_FILE 2>&1
     cd ./frontend && npm install
     echo "✅ frontend instalado correctamente."  >> ../$LOG_FILE 2>&1
     
     cd ..
     echo "⌛ Instalando paquetes de  merchandise..."  >> ../$LOG_FILE 2>&1
     cd ./merchandise && npm install
     
     echo "✅ merchandise instalado correctamente."  >> ../$LOG_FILE 2>&1
     cd ..
     echo "⌛ Instalando paquetes de  products..."  >> ../$LOG_FILE 2>&1
     cd ./products && npm install
     
     echo "✅ products instalado correctamente."  >> ../$LOG_FILE 2>&1
     cd ..
     echo "⌛ Instalando paquetes de shopping-cart..."  >> ../$LOG_FILE 2>&1
     cd ./"shopping-cart" && npm install
     
     echo "✅ shopping-cart instalado correctamente."  >> ../$LOG_FILE 2>&1
     cd ..
}

iniciar_ecommerce(){
    echo "⌛ Iniciando servicio frontend ..."  | tee -a ../$LOG_FILE
    pm2 start frontend/server.js --name frontend -- -p 3000  --env PRODUCTS_SERVICE=192.168.14.10:3001 \
         --env SHOPPING_CART_SERVICE=192.168.14.10:3002 \
        --env MERCHANDISE_SERVICE=192.168.14.10:3003 >> ../$LOG_FILE 2>&1
    echo "✅ Servicio frontend disponible."  >> ../$LOG_FILE 2>&1
    echo "⌛ Iniciando servicio products ..."  >> ../$LOG_FILE 2>&1
    pm2 start products/server.js --name products -- -p 3001 >> ../$LOG_FILE 2>&1
    echo "✅ Servicio products disponible."  >> ../$LOG_FILE 2>&1
    echo "⌛ Iniciando servicio shopping-cart ..."  >> ../$LOG_FILE 2>&1
    pm2 start shopping-cart/server.js --name shopping-cart -- -p 3002 >> ../$LOG_FILE 2>&1
    echo "✅ Servicio shopping-cart disponible."  >> ../$LOG_FILE 2>&1
    echo "⌛ Iniciando servicio merchandise ..."  >> ../$LOG_FILE 2>&1
    pm2 start merchandise/server.js --name merchandise -- -p 3003 >> ../$LOG_FILE 2>&1
    echo "✅ Servicio merchandise disponible."  >> ../$LOG_FILE 2>&1
}

main(){
    echo "******************************************"
    echo "********** DESPLEGANDO ECOMMERCE **********"
    echo "******************************************"
    instalar_dependencias
    clonar_repositorio
    instalar_paquetes
    iniciar_ecommerce
    echo "******************************************"
    echo "********** DESPLIEGUE TERMINADO **********"
    echo "******************************************"
}

main
