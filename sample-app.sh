#!/bin/bash

set -e

echo "===== INICIO DESPLIEGUE SAMPLE APP ====="

# Eliminar contenedor anterior si existe
docker rm -f samplerunning 2>/dev/null || true

# Eliminar archivos temporales anteriores
rm -rf tempdir

# Crear estructura temporal
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copiar aplicación
cp sample_app.py tempdir/
cp -r templates/. tempdir/templates/
cp -r static/. tempdir/static/

# Crear Dockerfile
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

echo "===== CONSTRUYENDO IMAGEN ====="

docker build -t sampleapp tempdir/

echo "===== EJECUTANDO CONTENEDOR ====="

docker run -d \
-p 8888:8888 \
--name samplerunning \
sampleapp

echo "===== CONTENEDORES ACTIVOS ====="

docker ps

echo "===== DESPLIEGUE FINALIZADO ====="
