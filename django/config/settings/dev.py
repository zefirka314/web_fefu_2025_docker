from .base import *

DEBUG = True

INSTALLED_APPS += [
    "fefu_lab",
    #'debug_toolbar',
    'django_extensions',
]

MIDDLEWARE = ['debug_toolbar.middleware.DebugToolbarMiddleware'] + MIDDLEWARE
ALLOWED_HOSTS = ['*']
INTERNAL_IPS = ['127.0.0.1']

# Для отладки
DEBUG_TOOLBAR_CONFIG = {
    'SHOW_TOOLBAR_CALLBACK': lambda request: True,
}
