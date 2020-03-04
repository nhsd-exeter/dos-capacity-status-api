import unittest
import json
from django.test import Client
from ..test_utils import TestUtils


class TestPutValidationVal0001(unittest.TestCase):
    "Tests for the VAL-0001 validation code for the PUT endpoint"

    def test_invalid_capacity_status_given_none(self):
        client = Client()

        data = "{}"

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
            (str(response.content).find("VAL-0001") > 0),
            "Response message is not as expected.",
        )


class TestPutValidationVal0002(unittest.TestCase):
    "Tests for the VAL-0002 validation code for the PUT endpoint"

    def test_invalid_capacity_status_given_number(self):
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
        )

    def test_invalid_capacity_status_given_text(self):
        client = Client()

        data = '{"capacityStatus":"PINK"}'

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
        )

    def test_invalid_capacity_status_given_blank(self):
        client = Client()

        data = '{"capacityStatus":""}'

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
        )


class TestPutValidationVal0003(unittest.TestCase):
    "Tests for the VAL-0003 validation code for the PUT endpoint"

    def test_invalid_reset_status_text(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": "Text"}'

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
            (str(response.content).find("VAL-0003") > 0),
            "Response message is not as expected.",
        )


class TestPutValidationVal0004(unittest.TestCase):
    "Tests for the VAL-0004 validation code for the PUT endpoint"

    def test_invalid_reset_status_in_given_too_low(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": -1}'

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
            (str(response.content).find("VAL-0004") > 0),
            "Response message is not as expected.",
        )

    def test_invalid_reset_status_in_given_too_high(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": 2345}'

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
            (str(response.content).find("VAL-0004") > 0),
            "Response message is not as expected.",
        )


class TestPutValidationVal0005(unittest.TestCase):
    "Tests for the VAL-0005 validation code for the PUT endpoint"

    def test_invalid_notes_greater_than_900(self):
        client = Client()

        too_many_notes = TestUtils.max_notes + "a"

        data = (
            '{"capacityStatus":"red",\
            "notes":"'
            + too_many_notes
            + '"}'
        )

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
            (str(response.content).find("VAL-0005") > 0),
            "Response message is not as expected.",
        )

