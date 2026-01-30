#!/usr/bin/env python3
# system-monitor.py - Monitorear sistema durante stress tests

import psutil
import time
import json
import matplotlib.pyplot as plt
from datetime import datetime
import threading
import requests

class SystemMonitor:
    def __init__(self):
        self.data = {
            'timestamps': [],
            'cpu_percent': [],
            'memory_percent': [],
            'disk_io': [],
            'network_io': [],
            'response_times': []
        }
        self.running = False
        self.app_url = "http://localhost:3001"
    
    def collect_system_metrics(self):
        """Recolectar métricas del sistema"""
        while self.running:
            timestamp = datetime.now()
            
            # CPU
            cpu_percent = psutil.cpu_percent(interval=1)
            
            # Memoria
            memory = psutil.virtual_memory()
            memory_percent = memory.percent
            
            # Disco
            disk = psutil.disk_io_counters()
            disk_io = disk.read_bytes + disk.write_bytes if disk else 0
            
            # Red
            network = psutil.net_io_counters()
            network_io = network.bytes_sent + network.bytes_recv if network else 0
            
            # App response time
            response_time = self.test_app_response()
            
            self.data['timestamps'].append(timestamp)
            self.data['cpu_percent'].append(cpu_percent)
            self.data['memory_percent'].append(memory_percent)
            self.data['disk_io'].append(disk_io)
            self.data['network_io'].append(network_io)
            self.data['response_times'].append(response_time)
            
            # Log en tiempo real
            print(f"🕐 {timestamp.strftime('%H:%M:%S')} | "
                  f"CPU: {cpu_percent:5.1f}% | "
                  f"RAM: {memory_percent:5.1f}% | "
                  f"App: {response_time:6.0f}ms")
            
            time.sleep(2)
    
    def test_app_response(self):
        """Probar tiempo de respuesta de la app"""
        try:
            start_time = time.time()
            response = requests.get(f"{self.app_url}/health", timeout=5)
            end_time = time.time()
            
            if response.status_code == 200:
                return (end_time - start_time) * 1000  # en ms
            else:
                return -1  # Error
        except:
            return -1  # Error
    
    def start_monitoring(self, duration=300):
        """Iniciar monitoreo por X segundos"""
        print(f"📊 Iniciando monitoreo por {duration} segundos...")
        print("📈 Métricas en tiempo real:")
        print("-" * 60)
        
        self.running = True
        
        # Iniciar thread de monitoreo
        monitor_thread = threading.Thread(target=self.collect_system_metrics)
        monitor_thread.start()
        
        # Esperar duración especificada
        time.sleep(duration)
        
        # Detener monitoreo
        self.running = False
        monitor_thread.join()
        
        print("-" * 60)
        print("📊 Monitoreo completado")
        
        self.generate_report()
    
    def generate_report(self):
        """Generar reporte visual"""
        if len(self.data['timestamps']) == 0:
            print("❌ No hay datos para generar reporte")
            return
        
        # Crear gráfico
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 10))
        fig.suptitle('🔥 System Stress Test Monitoring', fontsize=16)
        
        timestamps = self.data['timestamps']
        
        # CPU
        ax1.plot(timestamps, self.data['cpu_percent'], 'r-', linewidth=2)
        ax1.set_title('CPU Usage (%)')
        ax1.set_ylabel('%')
        ax1.grid(True)
        ax1.set_ylim(0, 100)
        
        # Memoria
        ax2.plot(timestamps, self.data['memory_percent'], 'b-', linewidth=2)
        ax2.set_title('Memory Usage (%)')
        ax2.set_ylabel('%')
        ax2.grid(True)
        ax2.set_ylim(0, 100)
        
        # Response Times
        valid_times = [t for t in self.data['response_times'] if t > 0]
        valid_timestamps = [timestamps[i] for i, t in enumerate(self.data['response_times']) if t > 0]
        
        if valid_times:
            ax3.plot(valid_timestamps, valid_times, 'g-', linewidth=2)
        ax3.set_title('App Response Time (ms)')
        ax3.set_ylabel('ms')
        ax3.grid(True)
        
        # Network I/O
        if len(self.data['network_io']) > 1:
            network_rates = []
            for i in range(1, len(self.data['network_io'])):
                rate = (self.data['network_io'][i] - self.data['network_io'][i-1]) / 2  # por segundo
                network_rates.append(rate / 1024 / 1024)  # MB/s
            
            ax4.plot(timestamps[1:], network_rates, 'm-', linewidth=2)
        ax4.set_title('Network I/O (MB/s)')
        ax4.set_ylabel('MB/s')
        ax4.grid(True)
        
        plt.tight_layout()
        plt.savefig('stress-test-monitoring.png', dpi=300, bbox_inches='tight')
        print("📊 Gráfico guardado: stress-test-monitoring.png")
        
        # Guardar datos JSON
        report_data = {
            'test_duration': len(self.data['timestamps']) * 2,  # segundos
            'avg_cpu': sum(self.data['cpu_percent']) / len(self.data['cpu_percent']),
            'max_cpu': max(self.data['cpu_percent']),
            'avg_memory': sum(self.data['memory_percent']) / len(self.data['memory_percent']),
            'max_memory': max(self.data['memory_percent']),
            'avg_response_time': sum(valid_times) / len(valid_times) if valid_times else 0,
            'max_response_time': max(valid_times) if valid_times else 0,
            'app_availability': len(valid_times) / len(self.data['response_times']) * 100
        }
        
        with open('stress-test-monitoring.json', 'w') as f:
            json.dump(report_data, f, indent=2)
        
        print("📋 Datos guardados: stress-test-monitoring.json")
        print()
        print("📊 RESUMEN:")
        print(f"   CPU promedio: {report_data['avg_cpu']:.1f}%")
        print(f"   CPU máximo: {report_data['max_cpu']:.1f}%")
        print(f"   RAM promedio: {report_data['avg_memory']:.1f}%")
        print(f"   RAM máximo: {report_data['max_memory']:.1f}%")
        print(f"   Response time promedio: {report_data['avg_response_time']:.0f}ms")
        print(f"   App disponibilidad: {report_data['app_availability']:.1f}%")

if __name__ == "__main__":
    import sys
    duration = int(sys.argv[1]) if len(sys.argv) > 1 else 120
    
    monitor = SystemMonitor()
    try:
        monitor.start_monitoring(duration)
    except KeyboardInterrupt:
        print("\n⏹️  Monitoreo detenido por usuario")
        monitor.running = False
        monitor.generate_report()