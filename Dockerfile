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
