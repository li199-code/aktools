FROM docker.1ms.run/python:3.13-slim-bullseye

WORKDIR /app

RUN pip install --upgrade pip

COPY . /app

RUN pip install --no-cache-dir --upgrade gunicorn akshare

RUN pip install --no-cache-dir .

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "aktools.main:app", "-k", "uvicorn.workers.UvicornWorker"]