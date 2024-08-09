from django.db import models
from django.core.validators import MinValueValidator

# local
from apps.common.models import HelperModel
from apps.accounts.models import User
from apps.shop.models import Product


def greater_than_zero_validator():
    pass


class Cart(HelperModel):

    user = models.ForeignKey(User, related_name='cart', on_delete=models.CASCADE)

    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    quantity = models.PositiveIntegerField(
        default=1, validators=[MinValueValidator(message='Value cannot be less than 1', limit_value=1)])

    class Meta:
        verbose_name = 'Cart'
        verbose_name_plural = 'Cart'
        unique_together = ['user', 'product']

    def __str__(self):
        return f'{self.user.full_name}\'s Cart'


class WishList(HelperModel):

    user = models.ForeignKey(User, related_name='wishlist', on_delete=models.CASCADE)

    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.user.full_name}\'s WishlIst'

    def save(self, *args, **kwargs):
        existing_item = WishList.objects.filter(product=self.product, user=self.user)

        if not existing_item:
            super().save(*args, **kwargs)
        else:
            pass

    class Meta:
        verbose_name = 'WishList'
        verbose_name_plural = 'WishList'
