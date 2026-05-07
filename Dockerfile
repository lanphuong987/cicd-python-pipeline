FROM python:3.13-slim

WORKDIR /app


# Cài dependencies hệ thống (nếu cần)
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libssl-dev \
    cargo \
    && rm -rf /var/lib/apt/lists/*

# Tạo virtual env (optional nhưng sạch)
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip

# Install calibre-web
RUN pip install calibreweb

# Port mặc định
EXPOSE 8083

# Run app
CMD ["cps"]