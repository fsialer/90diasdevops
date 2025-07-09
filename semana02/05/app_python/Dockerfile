FROM python:3.11-slim

WORKDIR /app

COPY app.py /app
COPY requirements.txt /app

RUN pip install --upgrade pip && pip install -r requirements.txt

EXPOSE 80

CMD ["python", "app.py"]