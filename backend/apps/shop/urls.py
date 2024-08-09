from django.urls import path
from .views import ProductDetailView, AllProducts

urlpatterns = [
    path('product/detail/', ProductDetailView.as_view(), name='product_detail'),
    path('all/', AllProducts.as_view(), name='all'),

]
