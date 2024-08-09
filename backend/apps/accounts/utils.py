
from django.core.mail import EmailMessage
from django.conf import settings
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.contrib.auth.tokens import default_token_generator
from django.urls import reverse
from django.contrib.sites.shortcuts import get_current_site

# custom
from .models import User


def send_welcome_email(email):
    user = User.objects.get(email=email)
    body = f"Hi {user.full_name}, \nThank you for registering with us, We appreciate and love you, enjoy shopping!"

    mail = EmailMessage(from_email=settings.DEFAULT_FROM_EMAIL,
                        subject="Welcome to Gadgets-Shop",
                        body=body,
                        to=[email],
                        )
    mail.send(fail_silently=True)


def send_password_reset_otp(email, request):
    current_site = get_current_site(request).domain
    user = User.objects.get(email=email)

    uidb64 = urlsafe_base64_encode(force_bytes(user.id))
    token = default_token_generator.make_token(user)
    url = reverse('reset_confirm', kwargs={'uidb64': uidb64, 'token': token})
    api_url = reverse('set_password')
    link = f"{current_site}{url}"
    part = f'please visit {link}\nor\nuse uibd64:{uidb64} and token:{token} on {api_url}'
    msg_body = f"""Dear {user.full_name},\nYou have requested password reset, {part}"""

    mail = EmailMessage(body=msg_body,
                        subject="Reset Your Password",
                        from_email=settings.DEFAULT_FROM_EMAIL,
                        to=[email]
                        )
    mail.send(fail_silently=True)
