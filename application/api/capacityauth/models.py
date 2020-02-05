from django.db import models
from django.contrib.auth.models import User

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
