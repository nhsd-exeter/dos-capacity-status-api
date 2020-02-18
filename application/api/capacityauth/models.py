from django.db import models
from django.contrib.auth.models import User
from rest_framework_api_key.models import AbstractAPIKey

from api.dos.models import Users
from api.dos.models import Services


class ApiDosUserAssociations(models.Model):
    apiuserid = models.ForeignKey(
        User, models.DO_NOTHING, db_column="apiuserid", blank=False, null=False
    )
    dosuserid = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = "api_dos_user_associations"

class DosUserAPIKey(AbstractAPIKey):
    dosuserid = models.IntegerField(blank=False, null=False)
    dosusername = models.CharField(unique=True, max_length=255)

    class Meta(AbstractAPIKey.Meta):
        verbose_name = "Capacity API Key for a DoS user"
        verbose_name_plural = "Capacity API keys for a DoS users"
