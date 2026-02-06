# Guía de Troubleshooting

## Docker Issues
- Container no inicia: docker-compose logs [service]
- Puerto ocupado: netstat -tulpn | grep :3000
- Sin espacio: docker system prune -f

## Database Issues
- Connection refused: docker-compose restart db
- Queries lentas: verificar indices

## Application Issues
- App no responde: verificar logs y recursos
- Memory leaks: reiniciar containers
