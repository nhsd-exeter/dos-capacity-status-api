import unittest

from datetime import datetime, timedelta
from .test_env import TestEnv


class TestHelper(unittest.TestCase):
    def check_response(
        self,
        json_response,
        service_uid=149198,
        service_name="Dentist - Castle View Dental Practice, Dudley",
        capacity_status="RED",
        expected_reset_date_time=True,
        reset_status_in=240,
        notes="Capacity status set by Capacity Status API",
        modified_by="TestUser",
    ):
        self.assertEqual(
            json_response["id"], service_uid,
        )
        self.assertEqual(
            json_response["name"], service_name,
        )
        self.assertEqual(
            json_response["status"], capacity_status,
        )
        if expected_reset_date_time:
            (expected_reset_time_str_upper, expected_reset_time_str_lower,) = self._get_expected_reset_time(
                reset_status_in=reset_status_in
            )

            self.assertGreater(
                json_response["resetDateTime"], expected_reset_time_str_lower,
            )
            self.assertLess(
                json_response["resetDateTime"], expected_reset_time_str_upper,
            )
        else:
            reset_date_time_present = "resetDateTime" in json_response
            self.assertFalse(
                reset_date_time_present, "A reset date time is present in the JSON response.",
            )
        self.assertEqual(
            json_response["notes"], notes,
        )
        self.assertGreaterEqual(
            json_response["modifiedDate"], TestEnv.expected_modified_time_str_lower,
        )
        self.assertLess(
            json_response["modifiedDate"], TestEnv.expected_modified_time_str_upper,
        )
        self.assertEqual(
            json_response["modifiedBy"], modified_by,
        )

    def _get_expected_reset_time(self, reset_status_in=240):
        current_time = datetime.now()
        expected_reset_time_upper = current_time + timedelta(minutes=reset_status_in) + timedelta(minutes=3)
        expected_reset_time_str_upper = expected_reset_time_upper.astimezone().strftime("%Y-%m-%dT%H:%M:%SZ")
        expected_reset_time_lower = current_time + timedelta(minutes=reset_status_in) - timedelta(minutes=3)
        expected_reset_time_str_lower = expected_reset_time_lower.astimezone().strftime("%Y-%m-%dT%H:%M:%SZ")

        return expected_reset_time_str_upper, expected_reset_time_str_lower
