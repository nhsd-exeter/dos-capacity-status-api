import unittest
import json
from django.test import Client
from ..test_env import TestEnv


class TestPatchView(unittest.TestCase):
    "Tests authorisation for the PATCH endpoint."

    def test_user_not_authorised(self):
        client = Client()

        data = '{"capacityStatus":"RED"}'

        response = client.patch(
            TestEnv.api_unauthorised_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestEnv.auth_headers,
        )

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
