from rest_framework import serializers
from rest_framework.exceptions import ValidationError, AuthenticationFailed
from django.contrib import auth
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from django.utils.http import urlsafe_base64_decode
from django.contrib.auth.tokens import default_token_generator

# custom
from .models import User
from .utils import send_welcome_email, send_password_reset_otp


class RegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length=100)
    first_name = serializers.CharField(max_length=100, min_length=1,)
    last_name = serializers.CharField(max_length=100, min_length=1)
    password = serializers.CharField(max_length=100, min_length=6, write_only=True)
    password_confirm = serializers.CharField(max_length=100, min_length=6, write_only=True)

    class Meta:
        model = User
        fields = [
            'email',
            'first_name',
            'last_name',
            'password',
            'password_confirm',
        ]

    def validate(self, attrs):
        email = attrs.get('email', None)
        first_name = attrs.get('first_name', None)
        last_name = attrs.get('last_name', None)
        password = attrs.get('password')
        password_confirm = attrs.get('password_confirm')

        if email is None:
            raise ValueError('Users must have an Email address')

        if not first_name:
            raise ValueError("Users must submit a First name")

        if not last_name:
            raise ValueError("Users must submit a Last name")

        if User.objects.filter(email=email).exists():
            raise ValidationError('User already exists, Please login')

        if password != password_confirm:
            raise ValidationError('Passwords do not Match, Please try again')

        return super().validate(attrs)

    def create(self, validated_data):
        email = validated_data.get('email')

        user = User.objects.create_user(email=email,
                                        first_name=validated_data.get('first_name'),
                                        last_name=validated_data.get('last_name'),
                                        password=validated_data.get('password'),
                                        )

        send_welcome_email(email)

        return user


class LoginSerializer(serializers.ModelSerializer):
    id = serializers.EmailField(max_length=100, read_only=True)
    email = serializers.EmailField(max_length=100)
    fullname = serializers.CharField(source='full_name', read_only=True)
    password = serializers.CharField(max_length=100, min_length=6, write_only=True)
    refresh = serializers.CharField(max_length=100, min_length=6, read_only=True)
    access = serializers.CharField(max_length=100, min_length=6, read_only=True)

    class Meta:
        model = User
        fields = [
            'id',
            'email',
            'fullname',
            'password',
            'refresh',
            'access',
        ]

    def validate(self, attrs):
        email = attrs.get('email', None)
        password = attrs.get('password', None)
        request = self.context.get('request')

        if email is None:
            raise ValidationError('Email must be provided')

        if password is None:
            raise ValidationError('Password must be provided')

        if not User.objects.filter(email=email).exists():
            raise ValidationError('Email does not exist!')

        user = auth.authenticate(request=request, email=email, password=password)

        if user is None:
            raise AuthenticationFailed("Invalid Password, Please try again")

        tokens = user.tokens

        return {
            'id': user.id,
            'email': user.email,
            'fullname': user.full_name,
            'refresh': tokens.get('refresh_token'),
            'access': tokens.get('access_token'),

        }


class LogoutSerilaizer(serializers.Serializer):
    token = serializers.CharField(required=True, write_only=True)

    default_error_messages = {"bad_token": ('Token is expired or invalid')}

    def validate(self, attrs):
        if not attrs.get('token'):
            raise ValueError('Token must be provided')
        return super().validate(attrs)

    def save(self, **kwargs):
        try:
            token = RefreshToken(self.token)
            token.blacklist()
        except TokenError:
            return self.fail('bad_token')


class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=100, required=True)

    def validate(self, attrs):
        email = attrs.get('email', None)
        request = self.context.get('request')

        if email is None:
            raise ValueError('Email field must be Provided')

        if not User.objects.filter(email=email).exists():
            raise ValidationError('You do not have an account with us')

        send_password_reset_otp(email, request)

        return super().validate(attrs)


class ChangePasswordSerializer(serializers.Serializer):
    """
    For validated/logged in users to change their passwords

    """
    old_password = serializers.CharField(max_length=100, min_length=6, write_only=True)
    password = serializers.CharField(max_length=100, min_length=6, write_only=True)
    password_confirm = serializers.CharField(max_length=100, min_length=6, write_only=True)

    def validate(self, attrs):
        request = self.context.get('request')
        old_password = attrs.get('old_password')
        password = attrs.get('password')
        password_confirm = attrs.get('password_confirm')
        temp_user = request.user
        temp_email = temp_user.email

        if password != password_confirm:
            raise ValidationError('Passwords do not Match, Please try again')

        user = auth.authenticate(request=request, email=temp_email, password=old_password)
        if user is not None:
            user.set_password(password)
            user.save()
            return user
        raise AuthenticationFailed('Incorrect password, try again')


class SetNewPasswordSerializer(serializers.Serializer):
    """
    For reseting passwords for users who forgot theirs

    """
    token = serializers.CharField(max_length=255, write_only=True, required=True)
    uidb64 = serializers.CharField(max_length=100, write_only=True, required=True)
    password = serializers.CharField(max_length=100, min_length=6, write_only=True, required=True)
    password_confirm = serializers.CharField(max_length=100, min_length=6, write_only=True, required=True)

    def validate(self, attrs):
        token = attrs.get('token')
        uidb64 = attrs.get('uidb64')
        password = attrs.get('password')
        password_confirm = attrs.get('password_confirm')

        if password != password_confirm:
            raise ValidationError('Passwords do not Match, Please try again')

        try:
            user_id = urlsafe_base64_decode(uidb64).decode()
            user = User.objects.get(id=user_id)
            if default_token_generator.check_token(token=token, user=user):
                user.set_password(password)
                user.save()
                return user
            return AuthenticationFailed(
                "Failed token, expired or invalid")
        except Exception:
            raise AuthenticationFailed(
                "Reset link is invalid or has expired")
