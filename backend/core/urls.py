from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
# from apps.common.views import GenerateNewAccountNo

from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi


schema_view = get_schema_view(
    openapi.Info(
        title="Snippets API",
        default_version='v1',
        description="Gadgets-Shop Documentation",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="lexmail.aa@gmail.com"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)


urlpatterns = [
    # docs
    path('swagger<format>/', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    path('', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),

    # admin
    path('admin/', admin.site.urls),

    # rest framework
    path('api-auth/', include('rest_framework.urls')),

    # simple jwt
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # accounts
    path('api/auth/', include('apps.accounts.urls')),

    # profiles
    path('api/profiles/', include('apps.profiles.urls')),

    # shop
    path('api/shop/', include('apps.shop.urls')),

    # Cart
    path('api/cart/', include('apps.cart.urls')),

    # Orders
    path('api/order/', include('apps.order.urls')),

]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

admin.site.site_header = "Gadgets-Shop"
admin.site.site_title = "Gadgets-Shop"
admin.site.index_title = "Welcome to Gadgets-Shop"
