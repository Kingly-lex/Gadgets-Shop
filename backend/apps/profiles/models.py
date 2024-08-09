from django.db import models
from phonenumber_field.modelfields import PhoneNumberField
from django.utils.translation import gettext_lazy as _
from django_countries.fields import CountryField
from PIL import Image
# from django.core.exceptions import ValidationError

# local imports
from apps.common.models import HelperModel
from apps.accounts.models import User


class Gender(models.TextChoices):
    MALE = "Male", _("Male")
    FEMALE = "Female", _("Female")
    OTHER = "Other", _("Other")


class Profile(HelperModel):
    user = models.OneToOneField(User, related_name='profile', on_delete=models.CASCADE)

    phone_number = PhoneNumberField(verbose_name=_("Phone Number"), region='NG',
                                    help_text=_("Eg: +234758849930"), max_length=30, null=True, blank=True)

    gender = models.CharField(choices=Gender.choices, default=Gender.OTHER, max_length=10)

    apt_no = models.CharField(max_length=255, verbose_name=_("Apartment number"), default=None, null=True, blank=True)

    address = models.TextField(max_length=255, verbose_name=_(
        "Your Home Address"), default=None, null=True, blank=True)

    additional_info = models.CharField(max_length=255, verbose_name=_(
        "Additional Information"), default=None, null=True, blank=True)

    city = models.CharField(verbose_name=_("City"), max_length=100, null=True, blank=True)

    region = models.CharField(verbose_name=_("Region"), max_length=100, null=True, blank=True)

    country = CountryField(verbose_name=_("Country"), default="NG")

    profile_photo = models.ImageField(verbose_name=_("Profile Photo"),
                                      default="default.jpg", upload_to="profile_images")

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

        img = Image.open(self.profile_photo.path)

        if img.height > 300 or img.width > 300:
            img_dimensions = (300, 300)
            img.thumbnail(img_dimensions)
            img.save(self.profile_photo.path)

    def __str__(self):
        return f"{self.user.full_name}'s Profile"


class DeliveryAddress(HelperModel):

    profile = models.ForeignKey(Profile, related_name='delivery_addresses', on_delete=models.CASCADE)

    apt_no = models.CharField(max_length=255, verbose_name=_("Apartment number"), null=True, blank=True)

    address = models.TextField(max_length=255, verbose_name=_("Address"))

    additional_info = models.CharField(max_length=255, verbose_name=_("Additional Information"), null=True, blank=True)

    city = models.CharField(verbose_name=_("City"), max_length=100)

    region = models.CharField(verbose_name=_("Region"), max_length=100, default='Anambra')

    def __str__(self):
        return f"{self.profile.user.full_name}'s Delivery Address"

    def save(self, *args, **kwargs):
        if DeliveryAddress.objects.filter(profile=self.profile).count() >= 3:
            # raise ValidationError('Profile cannot have more than 2 delivery addresses')
            return False
        return super(DeliveryAddress, self).save(*args, **kwargs)
