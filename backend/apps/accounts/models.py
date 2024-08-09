from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
import uuid
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from rest_framework_simplejwt.tokens import RefreshToken


# custom imports
from .managers import CustomUserManager


class Provider(models.TextChoices):
    Email = "Email", _('Email')
    Google = "Google", _('Google')
    Facebook = "Facebook", _('Facebook')


class User(AbstractBaseUser, PermissionsMixin):
    pkid = models.BigAutoField(primary_key=True, editable=False)
    id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    email = models.EmailField(max_length=100, unique=True, verbose_name=_("Email Address"))
    first_name = models.CharField(verbose_name=_("First Name"), max_length=50)
    last_name = models.CharField(verbose_name=_("Last Name"), max_length=50)
    provider = models.TextField(choices=Provider.choices, default=Provider.Email, max_length=20)

    is_active = models.BooleanField(default=True)
    is_verified = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    is_superadmin = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    date_joined = models.DateTimeField(default=timezone.now)
    last_login = models.DateTimeField(null=True, blank=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = [
        "first_name",
        "last_name",
    ]

    objects = CustomUserManager()

    @property
    def full_name(self):
        return f"{self.first_name.capitalize()} {self.last_name.capitalize()}"

    def __str__(self):
        return self.email

    @property
    def tokens(self):
        refresh = RefreshToken.for_user(self)

        tokens = {
            "access_token": str(refresh.access_token),
            "refresh_token": str(refresh)
        }

        return tokens
