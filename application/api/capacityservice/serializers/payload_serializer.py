from rest_framework import serializers

from ..validation import validation_rules

from datetime import datetime, timedelta

import logging

logger = logging.getLogger(__name__)

"""
This is the request payload serializer. It is responsible for:
    defining the correct format of the request payload model
    valdating the request payload
    converting the payload model to match the database model (in
    its flattened form), so we can pass the converted payload data
    straight to the database model serializer for database level
    validation and update.
"""
class CapacityStatusRequestPayloadSerializer(serializers.Serializer):

    # The choice of capacity status that are expected.
    CAPACITY_STATUS_CHOICES = (
        "RED",
        "Red",
        "red",
        "AMBER",
        "Amber",
        "amber",
        "GREEN",
        "Green",
        "green",
    )

    capacityStatus = serializers.ChoiceField(
        required=True,
        choices=CAPACITY_STATUS_CHOICES,
        help_text="The RAG status to set the service to.",
        error_messages={
            "required": validation_rules[1]["error_msg"],
            "invalid_choice": validation_rules[2]["error_msg"],
        },
    )
    notes = serializers.CharField(
        required=False,
        max_length=900,
        default="RAG status set by Capacity Service API",
        help_text="Optional field of up to 900 characters to add ad-hoc notes to this status update action. Any \
            notes provided will be appended to the end of the default notes set by the API, e.g. RAG status set \
                by the Capacity Service API - additional notes here.",
        error_messages={"max_length": validation_rules[5]["error_msg"]},
    )
    resetStatusIn = serializers.IntegerField(
        required=False,
        default=240,
        min_value=0,
        max_value=1440,
        help_text="The amount of time, specified in 1 minute blocks up to and including 24 hours (1440 minutes), \
            from the time the service status is updated by the request to reset the RAG status of the service back \
                to GREEN. If no value or 0 is provided, the reset time will default to 4 hours (240 minutes).",
        error_messages={
            "invalid": validation_rules[3]["error_msg"],
            "min_value": validation_rules[4]["error_msg_min_value"],
            "max_value": validation_rules[4]["error_msg_max_value"],
        },
    )

    """
    Converts the JSON payload (provided for PUT and PATCH requests) into the correct format
    for the serializer. Here we are taking the input fields of ResetStatusIn and capacityStatus
    and converting them to the correct values for the expected serializer fields for the
    resetdatetime and capacitystatus.
    """
    def convertToModel(self, data):

        logger.debug("Data in CapacityStatusRequestPayloadSerializer for model conversion: %s", data)

        payload_data =  super().validated_data

        reset_time = datetime.now() + timedelta(minutes=payload_data["resetStatusIn"])
        new_reset_dt = reset_time.astimezone().strftime("%Y-%m-%dT%H:%M:%SZ")
        data["resetdatetime"] = new_reset_dt

        # Set capacity status
        data["capacitystatus"] = {"color": payload_data["capacityStatus"]}
        
        # Set notes to be default note string plus any additional notes that have been
        # included in the request data
        notesfield = self.fields['notes']
        notesdefault = notesfield.to_representation(
            notesfield.get_default()
        )
        notes = notesdefault
        if "notes" in data:
            notes = notes + " - " + data["notes"]
        data["notes"] = notes

        # Set modified by - At the moment hardcoded, but this will eventually come from
        # the request header.
        data["modifiedby"]="API user"

        # Set modified date.
        data["modifieddate"]=datetime.now().astimezone().strftime("%Y-%m-%dT%H:%M:%SZ")

        logger.debug("Converted data from CapacityStatusRequestPayloadSerializer: %s", data)
        
        return data
    