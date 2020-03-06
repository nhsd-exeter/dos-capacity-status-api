import unittest
from django.test import Client
from ..test_env import TestEnv


class TestPatch404(unittest.TestCase):
    "Tests for handling service not found scenario for the PATCH endpoint"

    def test_no_service_found(self):
        client = Client()
        response = client.patch(
            TestEnv.api_no_service_url, HTTP_HOST="127.0.0.1", **TestEnv.auth_headers
        )

        self.assertEqual(
            response.status_code, 404, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content, b'"Given service does not exist"',
        )
