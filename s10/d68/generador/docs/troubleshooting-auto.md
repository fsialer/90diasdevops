# Troubleshooting Guide

## Docker

### Container Fails [Container_Fails]
**Severity:** high

**Solutions:**
- Check logs: docker-compose logs
- Restart: docker-compose restart

### Port Occupied [Port_Occupied]
**Severity:** medium

**Solutions:**
- Find process: netstat -tulpn | grep :3000
- Kill process or change port

## Application

### Db Connection [Db_Connection]
**Severity:** high

**Solutions:**
- Check DB status: docker-compose ps
- Restart DB: docker-compose restart db

### High Memory [High_Memory]
**Severity:** medium

**Solutions:**
- Check usage: docker stats
- Restart containers

