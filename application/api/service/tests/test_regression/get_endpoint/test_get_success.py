import unittest
import json
from django.test import Client, tag

from ..test_env import TestEnv


@tag("regression")
class TestGetSuccess(unittest.TestCase):
    "Tests success scenarios for the Get endpoint"

    client = Client()

    def test_get_success(self):
        response = self.client.get(TestEnv.api_unauthorised_url, HTTP_HOST=TestEnv.api_host, **TestEnv.auth_headers)
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        self.assertEqual(
            json_response["id"], 110798,
        )
        self.assertEqual(
            json_response["name"], "Dentist - Sneinton Family Dental Practice (Nottingham)",
        )
        self.assertEqual(
            json_response["status"], "GREEN",
        )

        reset_date_time_present = "resetDateTime" in json_response
        self.assertFalse(
            reset_date_time_present, "A reset date time is present in the JSON response.",
        )
        notes_present = "notes" in json_response
        self.assertFalse(
            notes_present, "Notes are present in the JSON response.",
        )
        modified_date_present = "modifiedDate" in json_response
        self.assertFalse(
            modified_date_present, "Modified Date is present in the JSON response.",
        )
        modified_by_present = "modifiedBy" in json_response
        self.assertFalse(
            modified_by_present, "Modified By is present in the JSON response.",
        )
