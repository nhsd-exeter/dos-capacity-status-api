from django.db import models
from django.contrib.auth.models import User
from rest_framework_api_key.models import AbstractAPIKey
from django.core.exceptions import (
    ValidationError,
    ObjectDoesNotExist,
    MultipleObjectsReturned,
)
import logging


from api.dos.queries import get_dos_user_for_username

logger = logging.getLogger(__name__)


class DosUserAPIKey(AbstractAPIKey):
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
            raise ValidationError(
                "Username '%(value)s' does not exist in DoS", params={"value": value}
            )
        except MultipleObjectsReturned:
            raise ValidationError(
                "Unexpected multiple DoS users with given username '%(value)s'",
                params={"value": value},
            )

    dos_user_id = models.IntegerField(blank=False, null=False)
    dos_username = models.CharField(
        unique=True, max_length=255, validators=[validate_dos_username_exists]
    )

    def save(self):
        self.name = self.dos_username
        self.dos_user_id = get_dos_user_for_username(self.dos_username).id
        return super().save()

    class Meta(AbstractAPIKey.Meta):
        verbose_name = "Capacity API Key for a DoS user"
        verbose_name_plural = "Capacity API keys for a DoS users"
