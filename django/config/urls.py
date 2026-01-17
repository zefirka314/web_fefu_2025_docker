from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from health.views import HealthCheckView

urlpatterns = [
    # Health check endpoint для мониторинга
    path('health/', HealthCheckView.as_view(), name='health_check'),
    
    # Административная панель Django
    path('admin/', admin.site.urls),
    
    # Основные маршруты приложения
    path('', include('fefu_lab.urls')),
]

# Обработчик 404 ошибок (страница не найдена)
handler404 = 'fefu_lab.views.custom_404'

# Добавляем статические и медиа файлы в режиме разработки
if settings.DEBUG:
    # Статические файлы (CSS, JavaScript, изображения)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    
    # Медиа файлы (загруженные пользователями)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    
    # Django Debug Toolbar (если используется)
    try:
        import debug_toolbar
        urlpatterns = [
            path('__debug__/', include(debug_toolbar.urls)),
        ] + urlpatterns
    except ImportError:
        # Debug Toolbar не установлен, пропускаем
        pass
