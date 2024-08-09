from django.db import models
from django.utils.translation import gettext_lazy as _

# Local
from apps.common.models import HelperModel
from apps.accounts.models import User
from apps.shop.models import Product


class Range(models.IntegerChoices):
    RATING_1 = 1, _("Poor")
    RATING_2 = 2, _("Fair")
    RATING_3 = 3, _("Good")
    RATING_4 = 4, _("Very Good")
    RATING_5 = 5, _("Excellent")


class Rating(HelperModel):

    user = models.ForeignKey(User, verbose_name=_("User providing the rating"), on_delete=models.CASCADE)

    product = models.ForeignKey(Product, verbose_name=_("Product being rated"),
                                related_name="product_rating", on_delete=models.CASCADE)

    rating = models.IntegerField(verbose_name=_("Rating"), choices=Range.choices,
                                 help_text="1=Poor, 2=Fair, 3=Good, 4=Very Good, 5=Excellent")

    comment = models.TextField(verbose_name=_("Comment"), null=True, blank=True)

    class Meta:

        unique_together = ["user", "product"]

        def __str__(self):
            return f"{self.product} rated at {self.rating} by{self.user.full_name}"

    def get_rating_display(self):
        for key, value in Range.choices:
            if key == self.rating:
                return value

    def __str__(self):
        return f"{self.user.full_name} rated {self.product.title} as {self.get_rating_display()}"
