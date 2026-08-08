#!/bin/bash

set -e

echo "===== INICIO DESPLIEGUE SAMPLE APP ====="

echo "===== ELIMINANDO CONTENEDOR ANTERIOR ====="
docker rm -f samplerunning 2>/dev/null || true

echo "===== PREPARANDO DIRECTORIO TEMPORAL ====="
rm -rf tempdir

mkdir -p tempdir/static
mkdir -p tempdir/templates

cp sample_app.py tempdir/
cp -r static/. tempdir/static/
cp -r templates/. tempdir/templates/

echo "===== CREANDO DOCKERFILE ====="

cat > tempdir/Dockerfile <<'EOF'
FROM python:3.10.5-slim-bullseye

WORKDIR /home/myapp

ENV PIP_PROGRESS_BAR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN python -m pip install --no-cache-dir --progress-bar off flask

COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

EXPOSE 8888

CMD ["python", "/home/myapp/sample_app.py"]
EOF

echo "===== CONSTRUYENDO IMAGEN DOCKER ====="

docker build --network=host -t sampleapp tempdir/

echo "===== EJECUTANDO CONTENEDOR ====="

docker run -d \
-p 8888:8888 \
--name samplerunning \
sampleapp

echo "===== ESPERANDO INICIO DE LA APLICACION ====="

sleep 5

echo "===== CONTENEDORES ACTIVOS ====="

docker ps

echo "===== VALIDANDO APLICACION ====="

docker exec samplerunning python -c \
'import urllib.request; print(urllib.request.urlopen("http://127.0.0.1:8888", timeout=10).read().decode())'

echo "===== DESPLIEGUE FINALIZADO CORRECTAMENTE ====="
