from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="API Básica", version="1.0.0")

class Item(BaseModel):
    name: str
    description: str = None
    price: float

@app.get("/")
def read_root():
    return {"message": "¡Hola! API básica con FastAPI"}

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}

@app.post("/items/")
def create_item(item: Item):
    return {"message": "Item creado", "item": item}