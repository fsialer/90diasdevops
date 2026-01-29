#!/usr/bin/env python3
import requests
import json
from datetime import datetime, timedelta
import os

# Configuración
REPO = os.environ.get('GITHUB_REPOSITORY', 'owner/repo')
TOKEN = os.environ.get('GITHUB_TOKEN')

headers = {
    'Authorization': f'token {TOKEN}',
    'Accept': 'application/vnd.github.v3+json'
}

def get_workflow_runs(days=7):
    """Obtener runs de los últimos N días"""
    since = (datetime.now() - timedelta(days=days)).isoformat()
    url = f'https://api.github.com/repos/{REPO}/actions/runs'
    
    params = {'created': f'>{since}', 'per_page': 100}
    response = requests.get(url, headers=headers, params=params)
    
    return response.json()['workflow_runs']

def calculate_metrics():
    """Calcular métricas clave"""
    runs = get_workflow_runs()
    
    if not runs:
        print("❌ No hay datos suficientes")
        return
    
    # Métricas básicas
    total = len(runs)
    successful = len([r for r in runs if r['conclusion'] == 'success'])
    failed = len([r for r in runs if r['conclusion'] == 'failure'])
    
    success_rate = (successful / total) * 100 if total > 0 else 0
    
    # Tiempo promedio
    durations = []
    for run in runs:
        if run['updated_at'] and run['created_at']:
            start = datetime.fromisoformat(run['created_at'].replace('Z', '+00:00'))
            end = datetime.fromisoformat(run['updated_at'].replace('Z', '+00:00'))
            duration = (end - start).total_seconds() / 60  # minutos
            durations.append(duration)
    
    avg_duration = sum(durations) / len(durations) if durations else 0
    
    # Generar reporte
    print("📊 MÉTRICAS DEL PIPELINE (últimos 7 días)")
    print("=" * 50)
    print(f"🚀 Total de ejecuciones: {total}")
    print(f"✅ Exitosas: {successful}")
    print(f"❌ Fallidas: {failed}")
    print(f"📈 Tasa de éxito: {success_rate:.1f}%")
    print(f"⏱️ Tiempo promedio: {avg_duration:.1f} minutos")
    print(f"🎯 Estado: {'🟢 EXCELENTE' if success_rate > 95 else '🟡 MEJORABLE' if success_rate > 85 else '🔴 CRÍTICO'}")
    
    # Guardar en archivo para GitHub Pages
    metrics = {
        'updated': datetime.now().isoformat(),
        'total_runs': total,
        'success_rate': round(success_rate, 1),
        'avg_duration_minutes': round(avg_duration, 1),
        'successful': successful,
        'failed': failed
    }
    
    with open('pipeline-metrics.json', 'w') as f:
        json.dump(metrics, f, indent=2)
    
    print("\n💾 Métricas guardadas en pipeline-metrics.json")

if __name__ == "__main__":
    calculate_metrics()