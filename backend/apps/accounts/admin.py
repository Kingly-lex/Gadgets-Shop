from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext_lazy as _

from .models import User
from apps.profiles.models import Profile, DeliveryAddress
from .forms import CustomUserChangeForm, CustomUserCreationForm


class AdminUser(UserAdmin):
    list_display_links = ['id', 'email', 'first_name', 'last_name']
    list_display = ['pkid', 'id', 'email', 'first_name', 'last_name', "is_staff", "is_active"]
    list_filter = ['email', 'first_name', 'last_name', "is_staff", "is_active"]
    filter_horizontal = ()
    ordering = ['id']
    model = User
    form = CustomUserChangeForm
    add_form = CustomUserCreationForm
    fieldsets = (
        (
            _("Login Credentials"),
            {
                "fields": (
                    "email",
                    "password",
                )
            },
        ),
        (
            _("Personal Information"),
            {
                "fields": (

                    "first_name",
                    "last_name",

                )
            },
        ),
        (
            _("Permissions and Groups"),
            {
                "fields": (
                    "is_active",
                    "is_verified",
                    "is_staff",
                    "is_admin",
                    "is_superadmin",
                    "is_superuser",
                    "groups",
                    "user_permissions",
                )
            },
        ),
        (_("Important Dates"), {"fields": ("last_login", "date_joined")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "password1", "password2", "is_staff", "is_active"),
            },
        ),
    )
    search_fields = ["email", "first_name", "last_name"]


class DeliveryAddressInline(admin.StackedInline):

    model = DeliveryAddress
    extra = 1

    class Meta:
        # proxy = True
        verbose_name_plural = 'Delivery Addresses'


class ProfileAdmin(admin.ModelAdmin):
    model = Profile

    class Meta:
        proxy = True


class UserProfileAdmin(ProfileAdmin):
    inlines = [DeliveryAddressInline]

    class Meta:
        proxy = True


admin.site.register(User, AdminUser)
admin.site.register(Profile, UserProfileAdmin)
# admin.site.register(DeliveryAddress)
