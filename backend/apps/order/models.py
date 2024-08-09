from django.db import models
from django.utils.translation import gettext_lazy as _

# local
from apps.accounts.models import User
from apps.cart.models import Cart
from apps.common.models import HelperModel


class OrderStatus(models.TextChoices):

    pending = 'pending', _('pending')
    accepted = 'accepted', _('accepted')
    successful = 'successful', _('successful')
    cancelled = 'cancelled', _('cancelled')
    shipped = 'shipped', _('shipped')


class PaymentStatus(models.TextChoices):

    pending = 'pending', _('pending')
    accepted = 'accepted', _('accepted')
    successful = 'successful', _('successful')
    cancelled = 'cancelled', _('cancelled')


class PaymentMethod(models.TextChoices):

    PAYSTACK = 'PAYSTACK', _('PAYSTACK')
    GOOGLEPAY = 'GOOGLEPAY', _('GOOGLEPAY')
    APPLEPAY = 'APPLEPAY', _('APPLEPAY')
    BANK_TRANSFER = 'BANK_TRANSFER', _('BANK_TRANSFER')


class Payment(HelperModel):

    user = models.ForeignKey(User, related_name='payments', on_delete=models.DO_NOTHING)

    payment_method = models.TextField(choices=PaymentMethod.choices, default=PaymentMethod.BANK_TRANSFER)

    transaction_id = models.TextField(
        max_length=250, help_text='Transaction ID of Payment Provider', blank=True, null=True)

    currency = models.CharField(max_length=50)

    amount = models.DecimalField(max_digits=10, decimal_places=2)

    status = models.CharField(choices=PaymentStatus.choices, default=PaymentStatus.pending)


class PlaceOrder(HelperModel):

    user = models.ForeignKey(User, related_name='placed_orders', on_delete=models.DO_NOTHING)

    items = models.ForeignKey(Cart, on_delete=models.DO_NOTHING)

    quantity = models.PositiveSmallIntegerField()

    delivery_address = models.TextField(max_length=255, verbose_name=_("Delivery Address"))

    total_amount = models.DecimalField(max_digits=10, decimal_places=2)

    payment_method = models.TextField(choices=PaymentMethod.choices, default=PaymentMethod.BANK_TRANSFER)

    currency = models.CharField(max_length=50)

    is_paid = models.BooleanField(default=False)

    status = models.TextField(choices=OrderStatus.choices, default=OrderStatus.pending)


class Order(HelperModel):
    user = models.ForeignKey(User, related_name='orders', on_delete=models.DO_NOTHING)
    placed_order = models.ForeignKey(PlaceOrder, related_name='verified_orders', on_delete=models.DO_NOTHING)
    payment = models.ForeignKey(Payment, related_name='payment_orders', on_delete=models.DO_NOTHING)
    fulfilled = models.BooleanField(default=False)
