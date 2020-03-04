import unittest
from django.test import Client

from ..test_utils import TestUtils


class TestGet404(unittest.TestCase):
    "Tests for the GET view"

    client = Client()

    def test_no_service_found(self):
        response = self.client.get(
            TestUtils.api_no_service_url,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        self.assertEqual(
            response.status_code, 404, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content, b'"Given service does not exist"',
        )
