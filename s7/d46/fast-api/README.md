# API Básica con FastAPI

## Instalación

```bash
pip install -r requirements.txt
```

## Ejecutar

```bash
uvicorn main:app --reload
```

## Endpoints

- `GET /` - Mensaje de bienvenida
- `GET /health` - Health check
- `GET /items/{item_id}` - Obtener item por ID
- `POST /items/` - Crear nuevo item

## Docker

```bash
docker build -t fastapi-basic .
docker run -p 8000:8000 fastapi-basic
```

La API estará disponible en http://localhost:8000
Documentación automática en http://localhost:8000/docs