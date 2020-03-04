import unittest
from django.test import Client
from ..test_utils import TestUtils


class TestPutAuthentication(unittest.TestCase):
    "Tests for the PUT view"

    def test_unauthorised_user_no_creds(self):
        client = Client()

        response = client.put(TestUtils.api_url)

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response status code is not as expected.",
        )
