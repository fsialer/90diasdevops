import time
import requests

# Esperar a que el servicio esté listo
def wait_for_service(url, timeout=30):
    for _ in range(timeout):
        try:
            r = requests.get(url)
            if r.status_code == 200:
                return True
        except:
            pass
        time.sleep(1)
    return False

def test_health_check():
    assert wait_for_service("http://vote-app:80/healthz"), "Service not healthy"
    resp = requests.get("http://vote-app:80/healthz")
    assert resp.status_code == 200
    data = resp.json()
    assert data["redis"] == "OK"
    assert data["database"] == "OK"

def test_stats_endpoint():
    resp = requests.get("http://vote-app:80/stats")
    assert resp.status_code == 200
    data = resp.json()
    assert "total_votes" in data
    assert "cats_votes" in data
    assert "dogs_votes" in data