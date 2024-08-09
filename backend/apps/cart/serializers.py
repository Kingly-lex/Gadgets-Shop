
from rest_framework import serializers
from rest_framework.validators import ValidationError


from apps.shop.serializers import ProductSerializer
from .models import Cart, WishList
from apps.shop.models import Product


class CartSerializer(serializers.ModelSerializer):

    product = ProductSerializer()

    class Meta:
        model = Cart
        fields = ['product', 'quantity']


class AddCartSerializer(serializers.Serializer):
    product_id = serializers.UUIDField(required=True)
    quantity = serializers.IntegerField(required=False)

    def validate(self, attrs):
        product_id = attrs.get('product_id', None)
        quantity = attrs.get('quantity', None)
        request = self.context.get('request')

        if product_id is None:
            raise ValidationError('product_id is required')

        if not Product.objects.filter(id=product_id).exists():
            raise ValidationError('Invalid product id')

        product = Product.objects.get(id=product_id)

        if quantity is not None and quantity > product.stock_available:
            raise ValidationError('Not enough available stock')

        if quantity is None:
            quantity = 1
        elif quantity <= 0:
            quantity = 1
        else:
            quantity = quantity

        if Cart.objects.filter(user=request.user, product=product).exists():
            cart_item = Cart.objects.filter(user=request.user, product=product).first()
            if product.stock_available > quantity:
                cart_item.quantity += quantity
                cart_item.save()
        else:
            Cart.objects.create(user=request.user, product=product, quantity=quantity)

        return super().validate(attrs)


class RemoveItemFromCartSerializer(serializers.Serializer):
    product_id = serializers.UUIDField(required=True)

    def validate(self, attrs):
        product_id = attrs.get('product_id', None)
        request = self.context.get('request')

        if product_id is None:
            raise ValidationError('product_id is required')

        if not Product.objects.filter(id=product_id).exists():
            raise ValidationError('Invalid product id')

        product = Product.objects.get(id=product_id)

        cart = Cart.objects.filter(user=request.user)

        for item in cart:
            if item.product == product:
                item.delete()

        return super().validate(attrs)


class CartItemQuantitySerializer(serializers.Serializer):
    product_id = serializers.UUIDField(required=True)

    def validate(self, attrs):
        product_id = attrs.get('product_id', None)

        if product_id is None:
            raise ValidationError('product_id is required')

        if not Product.objects.filter(id=product_id).exists():
            raise ValidationError('Invalid product id')

        return attrs


class SetCartItemQuantitySerializer(serializers.Serializer):
    product_id = serializers.UUIDField(required=True)
    quantity = serializers.IntegerField(required=True)

    def validate(self, attrs):
        product_id = attrs.get('product_id', None)
        quantity = attrs.get('quantity', None)
        product = Product.objects.get(id=product_id)

        if product_id is None:
            raise ValidationError('product_id is required')

        if quantity is None:
            raise ValidationError('quantity is required')

        if quantity <= 0:
            raise ValidationError('quantity must be positive integer greater than 0')

        if not Product.objects.filter(id=product_id).exists():
            raise ValidationError('Invalid product id')

        if quantity > product.stock_available:
            raise ValidationError('Not enough available stock')

        return attrs


class WishListSerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = WishList
        fields = ['product']


class AddWislistSerializer(serializers.ModelSerializer):
    product_id = serializers.UUIDField(required=True)
