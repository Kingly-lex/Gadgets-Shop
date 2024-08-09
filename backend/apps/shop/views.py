from rest_framework.generics import RetrieveAPIView,  ListAPIView
# from rest_framework import status
# from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
# from django.shortcuts import get_object_or_404
from rest_framework.exceptions import ValidationError, NotFound
import uuid
from rest_framework import filters
from django_filters.rest_framework.backends import DjangoFilterBackend

# local
from .serializers import ProductSerializer
from .models import Product


class ProductDetailView(RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = "id"

    def get_object(self):
        product_id = self.request.data.get('product_id', None)

        if product_id is None:
            raise ValidationError('product_id field is required')

        try:
            id = uuid.UUID(product_id, version=4)
            return self.get_queryset().get(id=id)

        except Product.DoesNotExist:
            raise NotFound("Product not found")

        except Exception:
            raise ValidationError("Invalid Product ID")


class AllProducts(ListAPIView):
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend,
                       filters.OrderingFilter, filters.SearchFilter]

    def get_queryset(self):
        return Product.objects.all()
