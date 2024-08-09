from __future__ import absolute_import, unicode_literals
from celery import Celery
from django.conf import settings
import os


os.environ.setdefault("DJANGO_SETTINGS_MODULE", 'core.settings')

app = Celery("core")

app.conf.enable_utc = False
app.conf.update(timezone="Africa/Lagos")

app.config_from_object(settings, namespace="CELERY")

app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)


@app.task(bind=True)
def debug_task(self):
    print(f"Request: {self.request!r}")
