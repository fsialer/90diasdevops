#!/usr/bin/env python3
# knowledge-base.py - Base de conocimiento de problemas

import json
import re
from datetime import datetime
from pathlib import Path

class KnowledgeBase:
    def __init__(self):
        self.kb_file = Path("knowledge-base.json")
        self.problems = self.load_knowledge_base()
        
    
    def load_knowledge_base(self):
        """Cargar base de conocimiento básica"""
        return {
            "docker": {
                "container_fails": {
                    "severity": "high",
                    "solutions":["Check logs: docker-compose logs", "Restart: docker-compose restart"]
                } ,
                "port_occupied":{
                    "severity": "medium",
                    "solutions":["Find process: netstat -tulpn | grep :3000", "Kill process or change port"]
                } ,
            },
            "application": {
                "db_connection":{
                     "severity": "high",
                     "solutions":["Check DB status: docker-compose ps", "Restart DB: docker-compose restart db"]
                } ,
                "high_memory":{
                    "severity": "medium",
                    "solutions":["Check usage: docker stats", "Restart containers"]
                } 
            }
        }
    
    def search_problems(self, query):
        """Buscar problemas por query simple"""
        results = []
        query_lower = query.lower()
        
        for category, problems in self.problems.items():
            for problem, data in problems.items():
                if query_lower in problem.lower():
                    results.append({
                        "problem": problem,
                        "category": category,
                        "solutions": data["solutions"],
                        "severity": data["severity"],
                        "match_text": problem
                    })
        
        return results
    
    def generate_troubleshooting_guide(self):
        """Generar guía simple"""
        guide = "# Troubleshooting Guide\n\n"
        
        for category, problems in self.problems.items():
            guide += f"## {category.title()}\n\n"
            for problem, data in problems.items():
                guide += f"### {problem.replace('_', ' ').title()} [{problem.title()}]\n"
                guide += f"**Severity:** {data['severity']}\n\n"
                guide += "**Solutions:**\n"
                for solution in data['solutions']:
                    guide += f"- {solution}\n"
                guide += "\n"
        
        return guide
        
       
        
    def interactive_troubleshooting(self):
        """Modo interactivo"""
        while True:
            user_input = input("\n🛠️ Describe tu problema (o 'exit'): ").strip()
            if user_input.lower() == "exit":
                print("👋 Saliendo...")
                break
            if not user_input:
                print("❌ Por favor describe el problema")
                return
            
            matches = self.search_problems(user_input)
            
            if not matches:
                print("🤔 No encontré problemas similares en la base de datos")
                print("💡 Intenta con otros términos como:")
                print("   • 'container not starting'")
                print("   • 'connection refused'")  
                print("   • 'out of memory'")
                print("   • 'high cpu usage'")
                return
            
            print(f"\n🎯 Encontré {len(matches)} posible(s) solución(es):")
            print("-" * 40)
            
            for i, match in enumerate(matches, 1):
                severity_emoji = "🔴" if match["severity"] == "high" else "🟡" if match["severity"] == "medium" else "🟢"
                
                print(f"\n{i}. {severity_emoji} {match['problem'].replace('_', ' ').title()}")
                print(f"   📂 Categoría: {match['category']}")
                print(f"   🎯 Coincidencia: {match['match_text']}")
                print("   🔧 Soluciones:")
                
                for j, solution in enumerate(match["solutions"], 1):
                    print(f"      {j}. {solution}")
            
            print(f"\n💾 Guía completa disponible en: docs/troubleshooting-auto.md")

if __name__ == "__main__":
    kb = KnowledgeBase()
    
    # Generar guía automática
    guide = kb.generate_troubleshooting_guide()
    print(guide)
    print("✅ Guía de troubleshooting generada")
    Path("docs").mkdir(exist_ok=True)
    Path("docs/troubleshooting-auto.md").write_text(guide)
    
    # Modo interactivo
    print("\n" + "="*50)
    kb.interactive_troubleshooting()