#!/usr/bin/env python3
# generate-docs.py - Generar documentación automáticamente

import os
import json
import subprocess
from datetime import datetime
from pathlib import Path
from pathlib import Path

class DocumentationGenerator:
    def __init__(self):
        self.project_root = Path(".")
        self.docs_dir = Path("docs")
        self.docs_dir.mkdir(exist_ok=True)
    
    def generate_project_overview(self):
        """Generar overview del proyecto"""
        overview = {
            "name": self.get_project_name(),
            "description": self.get_project_description(),
            "version": self.get_project_version(),
            "services": self.get_docker_services(),
            "ports": self.get_exposed_ports(),
            "dependencies": self.get_dependencies()
        }
        
        with open(self.docs_dir / "project-overview.json", "w") as f:
            json.dump(overview, f, indent=2)
        
        return overview
    
    def get_project_name(self):
        """Obtener nombre del proyecto"""
        if Path("package.json").exists():
            try:
                with open("package.json") as f:
                    return json.load(f).get("name", "devops-project")
            except:
                pass
        
        return Path.cwd().name
    
    def get_project_description(self):
        """Obtener descripción del proyecto"""
        if Path("package.json").exists():
            try:
                with open("package.json") as f:
                    return json.load(f).get("description", "DevOps Challenge Project")
            except:
                pass
        
        return "Sistema de monitoreo y despliegue automatizado"
    
    def get_project_version(self):
        """Obtener versión del proyecto"""
        try:
            result = subprocess.run(["git", "describe", "--tags", "--abbrev=0"], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                return result.stdout.strip()
        except:
            pass
        
        return "1.0.0"
    
    def get_docker_services(self):
        """Obtener servicios de Docker Compose"""
        if not Path("docker-compose.yml").exists():
            return []
        
        try:
            result = subprocess.run(["docker-compose", "config", "--services"], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                return result.stdout.strip().split('\n')
        except:
            pass
        
        return []
    
    def get_exposed_ports(self):
        """Obtener puertos expuestos"""
        ports = []
        
        if Path("docker-compose.yml").exists():
            try:
                with open("docker-compose.yml") as f:
                    content = f.read()
                    # Buscar patrones de puertos (simplificado)
                    import re
                    port_matches = re.findall(r'"(\d+):\d+"', content)
                    ports.extend(port_matches)
            except:
                pass
        
        return list(set(ports))
    
    def get_dependencies(self):
        """Obtener dependencias del proyecto"""
        deps = {}
        
        # Node.js dependencies
        if Path("package.json").exists():
            try:
                with open("package.json") as f:
                    data = json.load(f)
                    deps["node"] = list(data.get("dependencies", {}).keys())[:10]
            except:
                pass
        
        # Python dependencies
        if Path("requirements.txt").exists():
            try:
                with open("requirements.txt") as f:
                    deps["python"] = [line.strip().split('==')[0] 
                                    for line in f if line.strip() and not line.startswith('#')][:10]
            except:
                pass
        
        return deps
    
    def generate_api_docs(self):
        """Generar documentación de API si existe"""
        api_docs = {
            "endpoints": [],
            "authentication": "Bearer token",
            "base_url": "http://localhost:3000/api"
        }
        
        # Buscar definiciones de rutas (muy simplificado)
        api_files = list(Path(".").glob("**/*api*")) + list(Path(".").glob("**/*route*"))
        print(api_files)
        for file_path in api_files[:5]:  # Limitar a 5 archivos
            if file_path.suffix in ['.js', '.py', '.ts']:
                try:
                    with open(file_path) as f:
                        content = f.read()
                        # Buscar patrones básicos de endpoints
                        import re
                        endpoints = re.findall(r'@app\.route\(["\']([^"\']+)["\']', content)
                        endpoints += re.findall(r'app\.(get|post|put|delete)\(["\']([^"\']+)["\']', content)
                        
                        for endpoint in endpoints:
                            if isinstance(endpoint, tuple):
                                method, path = endpoint
                                api_docs["endpoints"].append({"method": method.upper(), "path": path})
                            else:
                                api_docs["endpoints"].append({"method": "GET", "path": endpoint})
                        
                except:
                    continue
        
        if api_docs["endpoints"]:
            with open(self.docs_dir / "api-reference.json", "w") as f:
                json.dump(api_docs, f, indent=2)
        
        return api_docs
    
    def generate_deployment_guide(self):
        """Generar guía de despliegue"""
        
        deployment_guide = "# Guía de Despliegue\n\n"
        deployment_guide += "## Despliegue Local\n"
        deployment_guide += "1. git clone <repository-url>\n"
        deployment_guide += "2. docker-compose up -d\n"
        deployment_guide += "3. curl http://localhost:3000/health\n\n"
        deployment_guide += "## Despliegue en Producción\n"
        deployment_guide += "1. Conectar SSH a servidor\n"
        deployment_guide += "2. Instalar Docker y Docker Compose\n"
        deployment_guide += "3. Clonar repo y configurar .env\n"
        deployment_guide += "4. docker-compose -f docker-compose.prod.yml up -d\n"

        with open(self.docs_dir / "deployment.md", "w") as f:
            f.write(deployment_guide)
        
        return deployment_guide
    
    def generate_troubleshooting_guide(self):
        """Generar guía de troubleshooting"""
        
        troubleshooting = "# Guía de Troubleshooting\n\n"
        troubleshooting += "## Docker Issues\n"
        troubleshooting += "- Container no inicia: docker-compose logs [service]\n"
        troubleshooting += "- Puerto ocupado: netstat -tulpn | grep :3000\n"
        troubleshooting += "- Sin espacio: docker system prune -f\n\n"
        troubleshooting += "## Database Issues\n"
        troubleshooting += "- Connection refused: docker-compose restart db\n"
        troubleshooting += "- Queries lentas: verificar indices\n\n"
        troubleshooting += "## Application Issues\n"
        troubleshooting += "- App no responde: verificar logs y recursos\n"
        troubleshooting += "- Memory leaks: reiniciar containers\n"
        
        with open(self.docs_dir / "troubleshooting.md", "w") as f:
            f.write(troubleshooting)
        
        return troubleshooting
        
        with open(self.docs_dir / "troubleshooting.md", "w") as f:
            f.write(troubleshooting)
        
        return troubleshooting
    
    def generate_docs_dashboard(self):
        """Generar dashboard HTML para documentación"""
        
        overview = self.generate_project_overview()
        
        # Crear HTML simple para dashboard
        html_content = f"""
        <h1>Documentation Dashboard</h1>
        <p>Project: {overview['name']}</p>
        <p>Version: {overview['version']}</p>
        <div>Services: {len(overview['services'])} containers</div>
        """
        
        with open(self.docs_dir / "index.html", "w") as f:
            f.write(f"""
<!DOCTYPE html>
<html>
<head><title>Documentation</title></head>
<body>{html_content}</body>
</html>
""")
        
        return "index.html"
    
    def generate_all_docs(self):
        """Generar toda la documentación"""
        print("📚 GENERANDO DOCUMENTACIÓN COMPLETA")
        print("=" * 40)
        
        # Generar cada sección
        print("📊 Generando overview del proyecto...")
        overview = self.generate_project_overview()
        
        print("🔌 Generando documentación de API...")
        api_docs = self.generate_api_docs()
        
        print("🚀 Generando guía de despliegue...")
        deployment = self.generate_deployment_guide()
        
        print("🔧 Generando guía de troubleshooting...")
        troubleshooting = self.generate_troubleshooting_guide()
        
        print("📊 Generando dashboard de documentación...")
        dashboard = self.generate_docs_dashboard()
        
        print(f"\n✅ Documentación generada en: {self.docs_dir.absolute()}")
        print(f"🌐 Abrir dashboard: file://{self.docs_dir.absolute()}/index.html")
        
        return {
            "overview": overview,
            "api_docs": api_docs,
            "deployment_guide": "deployment.md",
            "troubleshooting_guide": "troubleshooting.md",
            "dashboard": dashboard
        }

if __name__ == "__main__":
    generator = DocumentationGenerator()
    result = generator.generate_all_docs()
    
    print("\n📋 ARCHIVOS GENERADOS:")
    for doc_type, filename in result.items():
        if isinstance(filename, str):
            print(f"   • {doc_type}: {filename}")
        else:
            print(f"   • {doc_type}: datos generados")