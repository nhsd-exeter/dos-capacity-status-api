import unittest
import json
from django.test import Client


class TestGetView(unittest.TestCase):
    "Tests for the GET view"

    def test_unauthorised_user_no_creds(self):
        client = Client()

        response = client.get("/api/v0.0.1/capacity/services/149198/capacitystatus/")

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response status code is not as expected.",
        )

    def test_unauthorised_user_invalid_creds(self):
        client = Client()
        auth_headers = {
            "HTTP_AUTHORIZATION": "Api-Key xsEe8gfN.udOR2hw5P17gAXGAsMF9Q8HS45tN6naa",
        }

        response = client.get(
            "/api/v0.0.1/capacity/services/149198/capacitystatus/",
            HTTP_HOST="127.0.0.1",
            **auth_headers
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 200, "Response status code is not as expected."
        )
        self.assertEqual(json_response["serviceUid"], 149198)

