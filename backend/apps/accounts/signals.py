from django.dispatch import receiver
from django.db.models.signals import post_save

from .models import User
from apps.profiles.models import Profile


@receiver(post_save, sender=User)
def create_profile(sender, created, instance, **kwargs):
    if created:
        Profile.objects.create(user=instance)


post_save.connect(create_profile, sender=User)
