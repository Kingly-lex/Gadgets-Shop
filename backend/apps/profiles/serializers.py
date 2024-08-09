from rest_framework import serializers
from django_countries.serializer_fields import CountryField


# local imports
from apps.profiles.models import Profile, DeliveryAddress


class DeliveryAddressSerializer(serializers.ModelSerializer):

    class Meta:
        model = DeliveryAddress
        fields = [
            'id',
            'apt_no',
            'address',
            'additional_info',
            'city',
            'region',
        ]


class RetrieveProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.full_name')
    email = serializers.EmailField(source='user.email')
    country = CountryField(name_only=True)
    delivery_addresses = DeliveryAddressSerializer(many=True, read_only=True)

    class Meta:
        model = Profile
        fields = [
            'id',
            'email',
            'full_name',
            'phone_number',
            "gender",
            "apt_no",
            'address',
            'additional_info',
            'city',
            'region',
            'country',
            'delivery_addresses',
            'profile_photo',
        ]

        read_only_fields = [

            'id',
            'email',
            'full_name',
            'phone_number',
            "gender",
            "apt_no",
            'address',
            'additional_info',
            'city',
            'region',
            'country',
            'delivery_addresses',
            'profile_photo',
        ]


class UpdateProfileSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(source='user.email', read_only=True)
    first_name = serializers.CharField(source='user.first_name', write_only=True)
    last_name = serializers.CharField(source='user.last_name', write_only=True)
    full_name = serializers.CharField(source='user.full_name', read_only=True)
    country = CountryField(name_only=True)
    delivery_addresses = DeliveryAddressSerializer(many=True)

    class Meta:
        model = Profile
        fields = [
            'email',
            'first_name',
            'last_name',
            'full_name',
            'phone_number',
            "gender",
            "apt_no",
            'address',
            'additional_info',
            'city',
            'region',
            'country',
            'delivery_addresses',
            'profile_photo',
        ]
