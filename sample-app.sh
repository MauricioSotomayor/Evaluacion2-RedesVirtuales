#!/bin/bash

set -e

echo "===== INICIO DESPLIEGUE SAMPLE APP ====="

echo "===== ELIMINANDO CONTENEDOR ANTERIOR ====="
docker rm -f samplerunning 2>/dev/null || true

echo "===== CONSTRUYENDO IMAGEN DOCKER ====="
docker build --network=host -t sampleapp .

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
