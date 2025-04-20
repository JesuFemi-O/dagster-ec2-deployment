ARG PYTHON_IMAGE=python:3.10-slim
FROM $PYTHON_IMAGE

WORKDIR /project

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "--module-name", "definitions"]