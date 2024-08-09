from rest_framework.generics import (ListAPIView, GenericAPIView)
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from rest_framework.response import Response

# local
from .serializers import (CartSerializer, AddCartSerializer, WishListSerializer,
                          RemoveItemFromCartSerializer, CartItemQuantitySerializer, SetCartItemQuantitySerializer)
from apps.shop.models import Product
from .models import Cart, WishList


class CartView(ListAPIView):
    serializer_class = CartSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user).order_by('-updated_at')


class AddToCartView(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = AddCartSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            return Response({'response': 'Product added to cart'}, status=status.HTTP_200_OK)
        return Response({'response': 'Something went wrong, try again'}, status=status.HTTP_400_BAD_REQUEST)


class RemoveItemFromCart(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = RemoveItemFromCartSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            return Response({'response': 'item removed from cart'}, status=status.HTTP_200_OK)
        return Response({'response': 'Something went wrong, try again'}, status=status.HTTP_400_BAD_REQUEST)


class DecreaseCartItemQuantity(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CartItemQuantitySerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid(raise_exception=True):
            product = Product.objects.get(id=request.data.get('product_id'))

            try:
                cart = Cart.objects.get(user=request.user, product=product)

                if cart.quantity > 1:
                    cart.quantity -= 1
                    cart.save()
                    return Response(status=status.HTTP_200_OK)
                else:
                    return Response(status=status.HTTP_400_BAD_REQUEST)

            except Exception:
                return Response(status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_400_BAD_REQUEST)


class IncreaseCartItemQuantity(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = CartItemQuantitySerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid(raise_exception=True):
            product = Product.objects.get(id=serializer.data.get('product_id'))

            try:
                if product.is_available:
                    item = Cart.objects.get(user=request.user, product=product)
                    if product.stock_available > item.quantity:
                        item.quantity += 1
                        item.save()
                        return Response(status=status.HTTP_200_OK)
                    else:
                        return Response({'response': 'not enough stock quantity'}, status=status.HTTP_400_BAD_REQUEST)
                else:
                    return Response({'response': 'product is currently unavailable'},
                                    status=status.HTTP_400_BAD_REQUEST)
            except Exception:
                return Response(status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_400_BAD_REQUEST)


class SetCartItemQuantity(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = SetCartItemQuantitySerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid(raise_exception=True):
            product = Product.objects.get(id=serializer.data.get('product_id'))
            quantity = serializer.data.get('quantity')

            try:
                item = Cart.objects.get(user=request.user, product=product)
                if product.stock_available >= quantity:
                    item.quantity = quantity
                    item.save()
                    return Response({"response": "Product quantity has been updated"}, status=status.HTTP_200_OK)
                else:
                    return Response({'response': 'not enough stock quantity'}, status=status.HTTP_400_BAD_REQUEST)
            except Exception:
                return Response(status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_400_BAD_REQUEST)


class ClearCart(GenericAPIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        user = request.user

        try:
            items = Cart.objects.filter(user=user).all()
            items.delete()
            return Response({'response': "Cart has been cleared"}, status=status.HTTP_200_OK)
        except Exception:
            return Response({'response': "Bad request"}, status=status.HTTP_400_BAD_REQUEST)


class WishListView(ListAPIView):
    serializer_class = WishListSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return WishList.objects.filter(user=self.request.user).order_by('-updated_at')


class AddWishListView(ListAPIView):
    serializer_class = WishListSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            return Response({'response': 'Product added to Wishlist'}, status=status.HTTP_200_OK)
        return Response({'response': 'Something went wrong, try again'}, status=status.HTTP_400_BAD_REQUEST)
