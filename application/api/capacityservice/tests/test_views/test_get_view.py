import unittest
import json
from django.test import Client

from .test_utils import TestUtils


class TestGetView(unittest.TestCase):
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

    def test_authorised_user(self):
        response = self.client.get(
            TestUtils.api_url, HTTP_HOST="127.0.0.1", **TestUtils.auth_headers
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 200, "Response status code is not as expected."
        )

        self.assertEqual(json_response["serviceUid"], 149198)
        self.assertEqual(
            json_response["serviceName"],
            "Dentist - Castle View Dental Practice, Dudley",
        )

    def test_put_unauthorised_user_no_creds(self):
        response = self.client.put(TestUtils.api_url)

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response status code is not as expected.",
        )

    def test_put_no_service_found(self):
        response = self.client.put(
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

    """def test_invalid_capacity_status_given_number(self):
        client = Client()

        data = '{"capacityStatus":30}'

        response = client.put(
            TestUtils.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        )"""

    def test_invalid_capacity_status_given_text(self):
        data = '{"capacityStatus":"PINK"}'

        response = TestUtils.call_put_with_payload(data)

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        )

    def test_invalid_capacity_status_given_blank(self):
        data = '{"capacityStatus":""}'

        response = self.client.put(
            TestUtils.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        )

    def test_invalid_reset_status_in_given_too_low(self):
        data = '{"capacityStatus":"red",\
            "resetStatusIn": -1}'

        response = self.client.put(
            TestUtils.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0),
            "Response message is not as expected.",
        )

    def test_invalid_reset_status_in_given_too_high(self):
        data = '{"capacityStatus":"red",\
            "resetStatusIn": 2345}'

        response = self.client.put(
            TestUtils.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0),
            "Response message is not as expected.",
        )

    """def test_invalid_capacity_status_given_none(self):
        client = Client()

        data = '{"capacityStatus":}'

        response = client.put(
            TestUtils.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **TestUtils.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        )"""

