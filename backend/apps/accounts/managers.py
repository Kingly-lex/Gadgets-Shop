from django.contrib.auth.models import BaseUserManager
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _


class CustomUserManager(BaseUserManager):
    def validate_email(self, email):
        try:
            email = self.normalize_email(email)
            validate_email(email)
        except ValidationError:
            ValueError("Email address is not valid")

    def create_user(self, email, first_name, last_name, password, **extra_fields):
        if not email:
            raise ValueError(_("Users must have an Email address"))

        if not first_name:
            raise ValueError(_("Users must submit a First name"))

        if not last_name:
            raise ValueError(_("Users must submit a Last name"))

        self.validate_email(email)

        user = self.model(email=email, first_name=first_name, last_name=last_name)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, first_name, last_name, password):

        user = self.create_user(email, first_name, last_name, password)

        user.is_admin = True
        user.is_verified = True
        user.is_active = True
        user.is_staff = True
        user.is_superadmin = True
        user.is_superuser = True

        user.save(using=self._db)
        return user
