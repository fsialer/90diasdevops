from flask import Flask, request, jsonify
from models import Client
from db import SessionLocal, Base, engine
import redis
import os
import datetime


app = Flask(__name__)

# Crear las tablas en la base de datos
Base.metadata.create_all(bind=engine)

# Conexión a Redis
redis_url = os.getenv("REDIS_HOST")
r = redis.Redis.from_url(redis_url)

@app.route('/')
def home():
    return jsonify({
        'message': '¡Hola DevOps con Fernando!',
        'timestamp': datetime.datetime.now().isoformat(),
        'status': 'success'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'uptime': 'running'})

@app.route('/customers', methods=['GET'])
def get():
    db = SessionLocal()
    clients = db.query(Client).all()
    result = []

    for client in clients:
        result.append({
            "id": client.id,
            "name": client.name,
            "email": client.email
        })

    return jsonify(result)


@app.route('/customers', methods=['POST'])
def register():
    data = request.json
    name = data.get('name')
    email = data.get('email')

    if not name or not email:
        return jsonify({"error": "Name and email are required"}), 400

    # Guardar en PostgreSQL
    db = SessionLocal()
    client = Client(name=name, email=email)
    db.add(client)
    db.commit()
    db.refresh(client)

    # Guardar en Redis (puede ser solo un caché, por ejemplo)
    r.set(f"customer:{client.id}", f"{name}|{email}")

    return jsonify({"id": client.id, "name": name, "email": email})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)