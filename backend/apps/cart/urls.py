from django.urls import path

from .views import (CartView, AddToCartView, RemoveItemFromCart, ClearCart,
                    DecreaseCartItemQuantity, SetCartItemQuantity, IncreaseCartItemQuantity)


urlpatterns = [
    path('', CartView.as_view(), name='cart'),
    path('add/', AddToCartView.as_view(), name='add-to-cart'),
    path('remove/', RemoveItemFromCart.as_view(), name='remove-from-cart'),
    path('decrease/', DecreaseCartItemQuantity.as_view(), name='decrease-cart'),
    path('increase/', IncreaseCartItemQuantity.as_view(), name='increase-cart'),
    path('set-quantity/', SetCartItemQuantity.as_view(), name='set-cart-quantity'),
    path('clear/', ClearCart.as_view(), name='clear-cart'),
]
