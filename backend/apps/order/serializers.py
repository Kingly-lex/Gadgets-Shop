from rest_framework import serializers
from rest_framework.validators import ValidationError

# local
from apps.order.models import PlaceOrder, Order
from apps.cart.serializers import CartSerializer
from .utils import send_placed_order_notification


class PlaceOrderSerializer(serializers.ModelSerializer):
    payment_method = serializers.CharField(required=True)

    class Meta:
        model = PlaceOrder
        fields = [
            'id',
            'items',
            'quantity',
            'total_amount',
            'delivery_address',
            'payment_method',
            'created_at',
        ]

        required_fields = [
            'items',
            'quantity',
            'total_amount',
            'delivery_address',
            'payment_method',

        ]

        read_only_fields = [
            'id',
            'created_at',

        ]

    def validate(self, attrs):
        user = self.context.get('request').user
        items = attrs.get('items', None)
        quantity = attrs.get('quantity', None)
        total_amount = attrs.get('total_amount', None)
        delivery_address = attrs.get('delivery_address', None)
        payment_method = attrs.get('payment_method', None)

        if items is None:
            raise ValidationError('items must be Provided')

        if quantity is None:
            raise ValidationError('quantity must be Provided')

        if total_amount is None:
            raise ValidationError('total_amount must be Provided')

        if delivery_address is None:
            raise ValidationError('delivery_address must be Provided')

        if payment_method is None:
            raise ValidationError('payment_method must be Provided')

        try:
            placed_order = PlaceOrder()
            placed_order.user = user
            placed_order.items = items
            placed_order.quantity = quantity
            placed_order.total_amount = total_amount
            placed_order.delivery_address = delivery_address
            placed_order.payment_method = payment_method

            placed_order.save()

            send_placed_order_notification(order=placed_order, user=user)

        except Exception as e:
            raise serializers.ValidationError(e)

        return attrs


class OrderSerializer(serializers.ModelSerializer):

    items = CartSerializer()

    class Meta:
        model = PlaceOrder
        fields = [
            'id',
            'items',
            'quantity',
            'delivery_address',
            'total_amount',
            'payment_method',
            'currency',
            'status',
            'created_at',
        ]


class ViewOrdersSerializer(serializers.ModelSerializer):
    payment_id = serializers.CharField(source='payment.id')
    payment_method = serializers.CharField(source='payment.payment_method')
    orders = OrderSerializer()

    class Meta:
        model = Order
        fields = [
            'id',
            'created_at',
            'orders',
            'payment_id',
            'payment_method',
            'fulfilled',
        ]

        read_only_fields = [
            'id',
            'created_at',
            'orders',
            'payment_id',
            'payment_method',
            'fulfilled',
        ]
