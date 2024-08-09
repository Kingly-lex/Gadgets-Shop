from django.urls import path

# local
from .views import ViewProfile, UpdateProfile

urlpatterns = [
    path('me/', ViewProfile.as_view(), name='profile'),
    path('update/', UpdateProfile.as_view(), name='update-profile'),
]
