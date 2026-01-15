#!/bin/bash
# lambda-monitor.sh

echo "📊 Estado de funciones Lambda"
echo "================================"

echo "🔢 Total de funciones:"
awslocal lambda list-functions --query 'length(Functions)'

echo ""
echo "📋 Lista de funciones:"
awslocal lambda list-functions --query 'Functions[].[FunctionName,Runtime,LastModified]' --output table

echo ""
echo "💾 Tamaño de funciones:"
awslocal lambda list-functions --query 'Functions[].[FunctionName,CodeSize]' --output table

echo ""
echo "⏱️ Configuración de timeout:"
awslocal lambda list-functions --query 'Functions[].[FunctionName,Timeout]' --output table