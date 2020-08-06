from rest_framework import serializers

import logging

logger = logging.getLogger(__name__)

"""
This is the response serializer. It is responsible for:
    defining the correct format of the response model
    validating the response data
    converting model data to response data format
"""


class CapacityStatusResponseSerializer(serializers.Serializer):

    id = serializers.IntegerField(required=True, help_text="The ID of the service.",)

    name = serializers.CharField(required=True, help_text="The name of the service.",)

    status = serializers.CharField(required=True, help_text="The current capacity status of the service.",)

    resetDateTime = serializers.DateTimeField(
        required=False,
        help_text="The time when the capacity status will automatically revert back to a GREEN state \
            if the current capacity status is anything other than GREEN.",
    )

    notes = serializers.CharField(
        required=False, help_text="Notes associated with the capacity status of the service.",
    )

    modifiedBy = serializers.CharField(
        required=False, help_text="The user who last updated the capacity status of the service.",
    )

    modifiedDate = serializers.DateTimeField(
        required=False, help_text="The date and time of when the capacity status of the service was last updated.",
    )

    def convertModelToResponse(data):

        logger.debug("Data in CapacityStatusResponseSerializer for response conversion: %s", data)

        response_data = data

        service_data = data["service"]
        status_data = data["status"]

        response_data["id"] = service_data["uid"]
        response_data["name"] = service_data["name"]
        response_data["status"] = status_data["color"]
        if data["resetdatetime"] is not None:
            response_data["resetDateTime"] = data["resetdatetime"]
        if data["modifiedby"] is not None:
            response_data["modifiedBy"] = data["modifiedby"]
        if data["modifieddate"] is not None:
            response_data["modifiedDate"] = data["modifieddate"]
        if data["notes"] is None:
            response_data.pop("notes")
        response_data.pop("service")

        logger.debug("Converted data from CapacityStatusResponseSerializer: %s", response_data)

        return response_data
