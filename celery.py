import os
from celery import Celery
from django.conf import settings

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myapp.settings') # поменять путь

app = Celery('myapp') #поменять настройки

app.config_from_object('django.conf:settings', namespace='CELERY')

app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)

# Оптимизации
app.conf.worker_prefetch_multiplier = 4
app.conf.worker_max_tasks_per_child = 100
app.conf.worker_max_memory_per_child = 200000  # 200MB

@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')