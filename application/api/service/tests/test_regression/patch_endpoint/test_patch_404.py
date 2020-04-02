import unittest
from django.test import Client, tag
from ..test_env import TestEnv

@tag("regression")
class TestPatch404(unittest.TestCase):
    "Tests for handling service not found scenario for the PATCH endpoint"

    def test_no_service_found(self):
        client = Client()
        response = client.patch(
            TestEnv.api_no_service_url, HTTP_HOST=TestEnv.api_host, **TestEnv.auth_headers
        )

        self.assertEqual(
            response.status_code, 404, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content, b'"Given service does not exist"',
        )

    def test_inactive_service_found(self):
        client = Client()
        response = client.patch(
            TestEnv.api_inactive_service_url,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(
            response.status_code, 404, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content, b'"Given service does not have an active status"',
        )
