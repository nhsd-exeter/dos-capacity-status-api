from rest_framework import serializers

from ..models import Services, ServiceCapacities, Capacitystatuses

import logging

logger = logging.getLogger(__name__)

"""
This serializer models the DoS Services database table and contains only the
fields that we are interested in for the purposes of the application.
"""


class ServicesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Services
        fields = ("id", "uid", "name", "publicname")


"""
This serializer models the DoS Capacitystatuses database table and contains only the
fields that we are interested in for the purposes of the application.
"""


class CapacitystatusesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Capacitystatuses
        fields = ("color",)


"""
This serializer models the DoS ServiceCapacities database table and embeds within
it the two serializers defined above. It provides a flattend representation of the
data model for capacity status update and retrieval.
It is responsible for:
    capacity status retrieval
    database level validation
    capacity status update
"""


class CapacityStatusModelSerializer(serializers.ModelSerializer):

    service = ServicesSerializer(read_only=True)
    capacitystatus = CapacitystatusesSerializer(required=True)

    class Meta:
        model = ServiceCapacities
        fields = (
            "id",
            "notes",
            "modifiedbyid",
            "modifiedby",
            "modifieddate",
            "service",
            "resetdatetime",
            "capacitystatus",
        )

    """
    We are overriding the default method provided by the ModelSerializer class because
    we need to set the capacity status of the instance to a CapacityStatus instance.
    """

    def update(self, instance, validated_data):

        logger.debug(
            "Data passed into CapacityStatusModelSerializer for update: %s", validated_data,
        )

        ragStatusColor = validated_data.get("capacitystatus", instance.capacitystatus)["color"]
        capStatus = Capacitystatuses.objects.db_manager("dos").get(color=ragStatusColor)

        # Adapted from the super class's update method
        for attr, value in validated_data.items():
            if attr == "capacitystatus":
                setattr(instance, attr, capStatus)
            else:
                setattr(instance, attr, value)

        instance.save()

        return instance
