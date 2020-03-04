import unittest
from django.test import Client

from ..test_utils import TestUtils


class TestGetAuthentication(unittest.TestCase):
    "Tests for the GET view"

    client = Client()

    def test_unauthorised_user_no_creds(self):
        response = self.client.get(TestUtils.api_url)

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response message is not as expected.",
        )
