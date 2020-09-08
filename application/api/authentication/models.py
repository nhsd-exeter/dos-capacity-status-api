from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import (
    ValidationError,
    ObjectDoesNotExist,
    MultipleObjectsReturned,
)
import logging


from api.dos_interface.queries import get_dos_user_for_username

logger = logging.getLogger(__name__)


def validate_dos_username_exists(value):
    logger.info("Validate DoS user exists for name: " + str(value))
    try:
        user = get_dos_user_for_username(str(value))
        logger.debug("DoS user exists with values: %s", user)
        if user.status != "ACTIVE":
            raise ValidationError(
                "Username '%(value)s' is not an 'ACTIVE' DoS user",
                params={"value": value},
            )
    except ObjectDoesNotExist:
        raise ValidationError("Username '%(value)s' does not exist in DoS", params={"value": value})
    except MultipleObjectsReturned:
        raise ValidationError(
            "Unexpected multiple DoS users with given username '%(value)s'",
            params={"value": value},
        )


class CapacityAuthDosUser(models.Model):

    dos_user_id = models.IntegerField(blank=False, null=False)
    dos_username = models.CharField(unique=True, max_length=255, validators=[validate_dos_username_exists])
    user = models.OneToOneField(User, on_delete=models.CASCADE)

    def save(self, *args, **kwargs):
        self.dos_user_id = get_dos_user_for_username(self.dos_username).id
        return super().save()

    class Meta:
        verbose_name = "Capacity Auth DoS User"
        verbose_name_plural = "Capacity Auth DoS Users"
