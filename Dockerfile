FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE 1  # Предотвращаем создание .pyc файлов
ENV PYTHONUNBUFFERED 1         # Не буферизуем stdout/stderr

RUN apt-get update && apt-get install -y \
    build-essential \          # компил
    libpq-dev \                # Для постг
    && rm -rf /var/lib/apt/lists/*

#Настроить рабочую папку
WORKDIR /app

# устанавливаем все с файла
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# поменять настройки при запуске
CMD ["gunicorn", "myapp.wsgi:application", "--bind", "0.0.0.0:8000"]

#При релизе добавить ngnix