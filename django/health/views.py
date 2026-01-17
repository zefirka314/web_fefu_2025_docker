import time
from django.http import JsonResponse
from django.db import connection
from django.views import View
import psutil

class HealthCheckView(View):
    def get(self, request):
        # Проверка базы данных
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
            db_status = "healthy"
        except Exception:
            db_status = "unhealthy"

        # Проверка диска
        disk_usage = psutil.disk_usage('/').percent
        
        # Проверка памяти
        memory = psutil.virtual_memory()

        return JsonResponse({
            'status': 'healthy' if db_status == 'healthy' and disk_usage < 90 else 'unhealthy',
            'database': db_status,
            'disk_usage_percent': disk_usage,
            'memory_available_mb': memory.available // (1024 * 1024),
            'timestamp': time.time(),
        })
