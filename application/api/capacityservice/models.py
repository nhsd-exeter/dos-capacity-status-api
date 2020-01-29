from django.db import models


class Capacitystatuses(models.Model):
    capacitystatusid = models.AutoField(primary_key=True)
    color = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = "capacitystatuses"


class Changes(models.Model):
    id = models.CharField(primary_key=True, max_length=255)
    approvestatus = models.CharField(max_length=255)
    type = models.CharField(max_length=255)
    initiatorname = models.CharField(max_length=255)
    servicename = models.CharField(max_length=255)
    servicetype = models.CharField(max_length=255, blank=True, null=True)
    value = models.TextField()
    createdtimestamp = models.DateTimeField(blank=True, null=True)
    creatorsname = models.CharField(max_length=255, blank=True, null=True)
    modifiedtimestamp = models.DateTimeField(blank=True, null=True)
    modifiersname = models.CharField(max_length=255, blank=True, null=True)
    serviceid = models.ForeignKey(
        "Services", models.DO_NOTHING, db_column="serviceid", blank=True, null=True
    )
    externalsystem = models.CharField(max_length=100, blank=True, null=True)
    externalref = models.CharField(max_length=100, blank=True, null=True)
    message = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = "changes"


class Services(models.Model):
    uid = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    # TODO Not used attributes of the services table, will be removed once model stability is confirmed
    # odscode = models.CharField(max_length=255, blank=True, null=True)
    # isnational = models.CharField(max_length=255, blank=True, null=True)
    # openallhours = models.BooleanField()
    # publicreferralinstructions = models.TextField(blank=True, null=True)
    # telephonetriagereferralinstructions = models.TextField(blank=True, null=True)
    # restricttoreferrals = models.BooleanField()
    # address = models.CharField(max_length=512, blank=True, null=True)
    # town = models.CharField(max_length=255, blank=True, null=True)
    # postcode = models.CharField(max_length=255, blank=True, null=True)
    # easting = models.IntegerField(blank=True, null=True)
    # northing = models.IntegerField(blank=True, null=True)
    # publicphone = models.CharField(max_length=255, blank=True, null=True)
    # nonpublicphone = models.CharField(max_length=255, blank=True, null=True)
    # fax = models.CharField(max_length=255, blank=True, null=True)
    # email = models.CharField(max_length=255, blank=True, null=True)
    # web = models.CharField(max_length=512, blank=True, null=True)
    # createdby = models.CharField(max_length=255, blank=True, null=True)
    # createdtime = models.DateTimeField(blank=True, null=True)
    # modifiedby = models.CharField(max_length=255, blank=True, null=True)
    # modifiedtime = models.DateTimeField(blank=True, null=True)
    # lasttemplatename = models.TextField(blank=True, null=True)
    # lasttemplateid = models.IntegerField(blank=True, null=True)
    # typeid = models.IntegerField(blank=True, null=True)
    # parentid = models.ForeignKey(
    #     "self",
    #     models.DO_NOTHING,
    #     db_column="parentid",
    #     blank=True,
    #     null=True,
    #     related_name="fk_parent",
    # )
    # subregionid = models.ForeignKey(
    #     "self",
    #     models.DO_NOTHING,
    #     db_column="subregionid",
    #     blank=True,
    #     null=True,
    #     related_name="fk_subregionId",
    # )
    statusid = models.IntegerField(blank=True, null=True)
    # organisationid = models.IntegerField(blank=True, null=True)
    # returnifopenminutes = models.IntegerField(blank=True, null=True)
    publicname = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = "services"


class ServiceCapacities(models.Model):
    notes = models.TextField(blank=True, null=True)
    modifiedbyid = models.IntegerField(blank=True, null=True)
    modifiedby = models.TextField(blank=True, null=True)
    modifieddate = models.DateTimeField(blank=True, null=True)
    service = models.OneToOneField(
        Services, models.DO_NOTHING, db_column="serviceid", blank=True, null=True
    )
    capacitystatus = models.ForeignKey(
        Capacitystatuses,
        models.DO_NOTHING,
        db_column="capacitystatusid",
        blank=True,
        null=True,
    )
    resetdatetime = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = "servicecapacities"

