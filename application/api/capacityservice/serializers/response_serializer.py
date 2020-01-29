from rest_framework import serializers

from ..validation import validation_rules

import logging

logger = logging.getLogger(__name__)

"""
This is the response serializer. It is responsible for:
    defining the correct format of the response model 
    validating the response data
    converting model data to response data format
"""
class CapacityStatusResponseSerializer(serializers.Serializer):

    serviceUid = serializers.IntegerField(
        required=True,
        help_text="The UID identifier of the service.",
    )

    serviceName = serializers.CharField(
        required=True,
        help_text="The name of the service.",
    )

    capacityStatus = serializers.CharField(
        required=True,
        help_text="The current capacity status of the service.",
    )

    resetDateTime = serializers.DateTimeField(
        required=False,
        help_text="The time when the capacity status will automatically revert back to a GREEN state \
            if the current capacity status is anything other than GREEN.",
    )

    notes = serializers.CharField(
        required=False,
        help_text="Notes associated with the service.",
    )

    modifiedBy = serializers.CharField(
        required=False,
        help_text="The user who last updated the capacity status of the service.",
    )

    modifiedDate = serializers.DateTimeField(
        required=False,
        help_text="The date and time when the capacity status was last updated.",
    )

    def convertModelToResponse(data):

        logger.debug("Data in CapacityStatusResponseSerializer for response conversion: %s", data)

        response_data = data

        service_data = data["service"]
        capacitystatus_data = data["capacitystatus"]

        response_data["serviceUid"] = service_data["uid"]
        response_data["serviceName"] = service_data["name"]
        response_data["capacityStatus"] = capacitystatus_data["color"]
        if data["resetdatetime"] != None:
            response_data["resetDateTime"] = data["resetdatetime"]
        if data["modifiedby"] != None:
            response_data["modifiedBy"] = data["modifiedby"]
        if data["modifieddate"] != None:
            response_data["modifiedDate"] = data["modifieddate"]
        if data["notes"] == None:
            response_data.pop("notes")
        response_data.pop("service")
        response_data.pop("capacitystatus")

        logger.debug("Converted data from CapacityStatusResponseSerializer: %s", response_data)

        return response_data
