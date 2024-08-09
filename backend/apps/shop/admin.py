from django.contrib import admin

# Register your models here.
from .models import Product, ProductImage, Color, ScreenSize
from apps.ratings.models import Rating


class ProductImageInline(admin.TabularInline):

    model = ProductImage
    extra = 1
    can_delete = True


class ColorInline(admin.TabularInline):

    model = Color
    extra = 1
    can_delete = True

    def has_delete_permission(self, request, obj):
        return True


class ScreenSizeInline(admin.TabularInline):

    model = ScreenSize
    extra = 1
    can_delete = True


class Ratings(Rating):

    class Meta:
        proxy = True


class ProductAdmin(admin.ModelAdmin):
    prepopulated_fields = {'slug': ("title",)}
    inlines = [ProductImageInline, ColorInline, ScreenSizeInline]
    ordering = ['-created_at']
    list_display = ['id', 'title', 'price']

    def get_queryset(self, request):
        return super().get_queryset(request).prefetch_related('tags')


admin.site.register(Product, ProductAdmin)
admin.site.register(Ratings)
