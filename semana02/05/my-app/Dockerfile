FROM python:3.11-slim
WORKDIR /app
COPY app.py /app
COPY requirements.txt /app
RUN apt-get update && apt-get upgrade -y && pip install --upgrade pip && pip install -r requirements.txt && apt-get clean && rm -rf /var/lib/apt/lists/*
EXPOSE 80
ENV NOMBRE=FERNANDO
ENTRYPOINT [ "python", "app.py" ]
