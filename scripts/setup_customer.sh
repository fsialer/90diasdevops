curl -X POST http://localhost/customers \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'

curl http://localhost/customers \
    -H "Content-Type: application/json" 