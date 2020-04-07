import unittest
from django.test import Client, tag
from ..test_env import TestEnv


@tag("regression")
class TestPatchAuthentication(unittest.TestCase):
    "Tests for authentication scenarios for the Patch endpoint"

    client = Client()

    def test_unauthorised_user_no_creds(self):
        response = self.client.patch(TestEnv.api_url, HTTP_HOST=TestEnv.api_host,)

        self.assertEqual(response.status_code, 401, "Response status code is not as expected.")
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response status code is not as expected.",
        )

    def test_unauthorised_user_invalid_creds(self):
        response = self.client.patch(TestEnv.api_url, HTTP_HOST=TestEnv.api_host, **TestEnv.invalid_auth_headers)

        self.assertEqual(response.status_code, 401, "Response status code is not as expected.")
        self.assertEqual(
            response.content, b'{"detail":"Invalid token."}', "Response message is not as expected.",
        )

    def test_user_not_active(self):
        response = self.client.patch(TestEnv.api_url, HTTP_HOST=TestEnv.api_host, **TestEnv.inactive_auth_headers)
        self.assertEqual(response.status_code, 401, "Response status code is not as expected.")
        self.assertEqual(
            response.content,
            b'"Given Dos user does not have an active status"',
            "Response message is not as expected.",
        )
