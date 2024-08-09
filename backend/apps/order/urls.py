from django.urls import path
from .views import PlaceOrderView, ViewOrders


urlpatterns = [
    path('place-order/', PlaceOrderView.as_view(), name='place-order'),
    path('view/', ViewOrders.as_view(), name='view-orders'),
]
