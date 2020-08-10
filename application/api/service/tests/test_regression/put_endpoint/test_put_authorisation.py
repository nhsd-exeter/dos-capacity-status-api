import unittest
from django.test import Client, tag
from ..test_env import TestEnv


@tag("regression")
class TestPutView(unittest.TestCase):
    "Tests authorisation for the PUT endpoint."

    def test_user_not_authorised(self):
        client = Client()

        data = '{"status":"RED"}'

        response = client.put(
            TestEnv.api_unauthorised_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 403, "Response status code is not as expected.")
