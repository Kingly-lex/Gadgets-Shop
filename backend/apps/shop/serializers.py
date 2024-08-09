from rest_framework import serializers
# from rest_framework.exceptions import ValidationError

from .models import Product, ProductImage, Color, ScreenSize


class ProductImageSerializer(serializers.ModelSerializer):
    image = serializers.ImageField()
    caption = serializers.CharField()

    class Meta:
        model = ProductImage
        fields = ['image', 'caption']
        read_only_fields = ['image', 'caption']


class ProductColorSerializer(serializers.ModelSerializer):
    color = serializers.CharField()

    class Meta:
        model = Color
        fields = ['color']
        read_only_fields = ['color']


class ProductSizeSerializer(serializers.ModelSerializer):
    size = serializers.CharField()

    class Meta:
        model = ScreenSize
        fields = ['size']
        read_only_fields = ['size']


class ProductSerializer(serializers.ModelSerializer):
    images = ProductImageSerializer(many=True, read_only=True)
    screen_sizes = ProductSizeSerializer(many=True, read_only=True)
    colors = ProductColorSerializer(many=True, read_only=True)

    class Meta:
        model = Product
        fields = [
            'id',
            'category',
            'title',
            'slug',
            'brand',
            'price',
            'description',
            'specifications',
            'discount_percentage',
            'stock_available',
            # 'tags',
            'display_image',
            'images',
            'colors',
            'screen_sizes',
            'is_available',
            'average_rating',
            'rating_count',
        ]
        read_only_fields = [
            'category',
            'title',
            'slug',
            'brand',
            'price',
            'description',
            'specifications',
            'discount_percentage',
            'stock_available',
            # 'tags',
            'display_image',
            'images',
            'colors',
            'screen_sizes',
            'is_available',
            'average_rating',
            'rating_count',
        ]

    # def get_product_rating(self, obj):
    #     return obj.product_rating
