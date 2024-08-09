from django.db import models
from django.utils.translation import gettext_lazy as _
from autoslug import AutoSlugField
from PIL import Image
from taggit.managers import TaggableManager

# local
from apps.common.models import HelperModel


def product_directory_path(instance, filename):
    # file will be uploaded to MEDIA_ROOT/product_<id>/<filename>
    return f"products/{instance.id}/{filename}"


def product_images_directory_path(instance, filename):
    return f"products/{instance.product.id}/more-images/{filename}"


class ProductCategory(models.TextChoices):

    Phones = 'Phones', _('Phones')

    Laptops = 'Laptops', _('Laptops')

    Desktops = 'Desktops', _('Desktops')

    Video_games = 'Video_games', _('Video_games')

    Tvs_Monitors = 'Tvs & Monitors', _('Tvs & Monitors')

    Accessories = 'Accessories', _('Accessories')

    Others = 'Others', _('Others')


class Product(HelperModel):

    category = models.CharField(choices=ProductCategory.choices, max_length=100,
                                default=ProductCategory.Others)

    title = models.TextField(max_length=50, verbose_name="Title")

    slug = AutoSlugField(populate_from='title', editable=True, always_update=True)

    brand = models.CharField(max_length=50, verbose_name="Brand", blank=True, null=True)

    price = models.DecimalField(max_digits=10, decimal_places=2)

    description = models.TextField(max_length=500, blank=True)

    specifications = models.TextField(max_length=500, blank=True, null=True)

    discount_percentage = models.SmallIntegerField(default=0)

    stock_available = models.PositiveBigIntegerField()

    tags = TaggableManager()

    display_image = models.ImageField(upload_to=product_directory_path)

    @property
    def is_available(self):
        return True if self.stock_available > 0 else False

    @property
    def rating_count(self):
        return self.product_rating.all().count()

    @property
    def average_rating(self):
        ratings = self.product_rating.all()

        if ratings.count() > 0:
            total_rating = sum(rating.rating for rating in ratings)
            average_rating = total_rating / ratings.count()
            return round(average_rating, 2)
        return None

    class Meta:
        ordering = ['-created_at']

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

        img = Image.open(self.display_image.path)

        if img.height > 500 or img.width > 500:
            img_dimensions = (500, 500)
            img.thumbnail(img_dimensions)
            img.save(self.display_image.path)

    def __str__(self) -> str:
        return self.slug


class ProductImage(HelperModel):

    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')

    image = models.ImageField(upload_to=product_images_directory_path)

    caption = models.CharField(max_length=50, blank=True, null=True)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

        img = Image.open(self.image.path)

        if img.height > 800 or img.width > 800:
            img_dimensions = (800, 800)
            img.thumbnail(img_dimensions)
            img.save(self.image.path)

    def __str__(self):
        return f'{self.product.title}\'s Images'


class Color(HelperModel):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='colors')
    color = models.CharField(max_length=50)

    def __str__(self) -> str:
        return f'Product color: {self.color}'


class ScreenSize(HelperModel):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='screen_sizes')
    size = models.CharField(max_length=50)

    def __str__(self) -> str:
        return f'Product size: {self.size}'
