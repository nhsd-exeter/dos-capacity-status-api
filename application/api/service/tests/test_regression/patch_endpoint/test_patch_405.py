import unittest
from django.test import Client, tag
from ..test_env import TestEnv


@tag("regression")
class TestPatch405(unittest.TestCase):
    "Tests for handling method not allowed scenario for the PATCH endpoint"

    def test_method_not_allowed(self):
        client = Client()
        response = client.patch(TestEnv.api_url, HTTP_HOST=TestEnv.api_host, **TestEnv.auth_headers)

        self.assertEqual(response.status_code, 405, "Response status code is not as expected.")
