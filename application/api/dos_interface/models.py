from django.db import models


class Services(models.Model):

    uid = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    statusid = models.IntegerField(blank=True, null=True)
    publicname = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = "services"


class Capacitystatuses(models.Model):
    capacitystatusid = models.AutoField(primary_key=True)
    color = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = "capacitystatuses"


class Users(models.Model):
    username = models.CharField(unique=True, max_length=255)
    email = models.CharField(max_length=255, blank=True, null=True)
    status = models.CharField(max_length=255, blank=True, null=True)
    homeorganisation = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = "users"


class ServiceCapacities(models.Model):
    notes = models.TextField(blank=True, null=True)
    modifiedbyid = models.IntegerField(blank=True, null=True)
    modifiedby = models.TextField(blank=True, null=True)
    modifieddate = models.DateTimeField(blank=True, null=True)
    service = models.OneToOneField(Services, models.DO_NOTHING, db_column="serviceid", blank=True, null=True)
    status = models.ForeignKey(
        Capacitystatuses, models.DO_NOTHING, db_column="capacitystatusid", blank=True, null=True,
    )
    resetdatetime = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = "servicecapacities"
