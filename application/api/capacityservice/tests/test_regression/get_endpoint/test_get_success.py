import unittest
import json
from django.test import Client

from ..test_utils import TestUtils


class TestGetSuccess(unittest.TestCase):
    "Tests for the GET view"

    client = Client()

    def test_get_success(self):
        response = self.client.get(
            TestUtils.api_url, HTTP_HOST="127.0.0.1", **TestUtils.auth_headers
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 200, "Response status code is not as expected."
        )

        self.assertEqual(json_response["serviceUid"], 149198)
        self.assertEqual(
            json_response["serviceName"],
            "Dentist - Castle View Dental Practice, Dudley",
        )
