FROM python:3.10-slim-bullseye

# Instala dependências de sistema necessárias para o Taiga
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    binutils \
    libpq-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    gettext \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /taiga-back

# Copia os arquivos de requisitos e instala as dependências do Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o código-fonte do backend
COPY . .

EXPOSE 8000

# Executa as migrações e sobe o servidor via Gunicorn
CMD ["gunicorn", "taiga.wsgi:application", "-b", "0.0.0.0:8000", "-w", "4"]
