import unittest

from datetime import datetime, timedelta

from ...serializers.payload_serializer import CapacityStatusRequestPayloadSerializer


class TestPayloadSerializer(unittest.TestCase):
    "Tests for the PayloadSerializer class"

    capacity_status = "Red"
    reset_status_in = 10
    notes = "Additional notes"
    api_username = "capApi"

    def test_reset_time_1(self):
        "Test reset_time method for RED status update"

        payload_data = {
            "capacityStatus": self.capacity_status,
            "resetStatusIn": 300,
        }
        current_time = datetime.now()
        expected_reset_time = current_time + timedelta(
            minutes=payload_data["resetStatusIn"]
        )
        expected_reset_time_str = expected_reset_time.astimezone().strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        )

        returned_reset_time = CapacityStatusRequestPayloadSerializer._resetTime(
            self, current_time, payload_data
        )

        self.assertEqual(
            returned_reset_time,
            expected_reset_time_str,
            "Returned reset data time is not as expected.",
        )

    def test_reset_time_2(self):
        "Test reset_time method for AMBER status update"

        payload_data = {
            "capacityStatus": "AMBER",
            "resetStatusIn": 300,
        }
        current_time = datetime.now()
        expected_reset_time = current_time + timedelta(
            minutes=payload_data["resetStatusIn"]
        )
        expected_reset_time_str = expected_reset_time.astimezone().strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        )

        returned_reset_time = CapacityStatusRequestPayloadSerializer._resetTime(
            self, current_time, payload_data
        )

        self.assertEqual(
            returned_reset_time,
            expected_reset_time_str,
            "Returned reset data time is not as expected.",
        )

    def test_reset_time_3(self):
        "Test reset_time method for GREEN status update"

        payload_data = {
            "capacityStatus": "GREEN",
            "resetStatusIn": 300,
        }
        current_time = datetime.now()

        returned_reset_time = CapacityStatusRequestPayloadSerializer._resetTime(
            self, current_time, payload_data
        )

        self.assertIsNone(
            returned_reset_time, "Returned reset data time is not None.",
        )

    def test_convert_to_model_1(self):
        "Test serializer with full and valid payload turning to red status"

        full_payload_data = {
            "capacityStatus": self.capacity_status,
            "resetStatusIn": self.reset_status_in,
            "notes": self.notes,
            "apiUsername": self.api_username,
        }

        request_payload_serializer = CapacityStatusRequestPayloadSerializer(
            data=full_payload_data
        )
        request_payload_serializer.is_valid()
        model_data = request_payload_serializer.convertToModel(full_payload_data)

        # Reset date time should be 10 mins from now, give or take a sec or too, so
        # don't be too strict on checking
        current_time = datetime.now()

        # Perform assertions
        self.assertDictEqual(
            model_data["capacitystatus"],
            {"color": "RED"},
            "Model capacity status data incorrectly set",
        )

        model_reset_time_str = model_data["resetdatetime"]
        model_reset_time_dt = datetime.strptime(
            model_reset_time_str, "%Y-%m-%dT%H:%M:%SZ"
        )
        self.assertLessEqual(
            model_reset_time_dt,
            current_time + timedelta(minutes=(self.reset_status_in + 1)),
            "Model reset date time data is a value greater than expected",
        )
        self.assertGreaterEqual(
            model_reset_time_dt,
            current_time + timedelta(minutes=(self.reset_status_in - 1)),
            "Model reset date time data is a value less than expected",
        )

        self.assertEqual(
            model_data["notes"],
            "RAG status set by Capacity Service API - Additional notes",
            "Model notes data incorrectly set",
        )

        self.assertEqual(
            model_data["modifiedby"],
            self.api_username,
            "Model modified by data incorrectly set",
        )

        modified_date_dt = datetime.strptime(
            model_data["modifieddate"], "%Y-%m-%dT%H:%M:%SZ"
        )
        self.assertLessEqual(
            modified_date_dt,
            current_time + timedelta(minutes=1),
            "Model modified date is a value greater than expected",
        )
        self.assertGreaterEqual(
            modified_date_dt,
            current_time + timedelta(minutes=-1),
            "Model modified date is a value less than expected",
        )
