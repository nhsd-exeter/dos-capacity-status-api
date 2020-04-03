import unittest
from django.test import Client, tag
from ..test_env import TestEnv


@tag("regression")
class TestPatchValidationVal0001(unittest.TestCase):
    "Tests for the VAL-0001 validation code for the Patch endpoint"

    def test_invalid_capacity_status_given_none(self):
        client = Client()

        data = "{}"

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0001") > 0), "Response message is not as expected.",
        )


class TestPatchValidationVal0002(unittest.TestCase):
    "Tests for the VAL-0002 validation code for the Patch endpoint"

    def test_invalid_capacity_status_given_number(self):
        client = Client()

        data = '{"capacityStatus":30}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0), "Response message is not as expected.",
        )

    def test_invalid_capacity_status_given_text(self):
        client = Client()

        data = '{"capacityStatus":"PINK"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0), "Response message is not as expected.",
        )

    def test_invalid_capacity_status_given_blank(self):
        client = Client()

        data = '{"capacityStatus":""}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0), "Response message is not as expected.",
        )


class TestPatchValidationVal0003(unittest.TestCase):
    "Tests for the VAL-0003 validation code for the Patch endpoint"

    def test_invalid_reset_status_text(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": "Text"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0003") > 0), "Response message is not as expected.",
        )

    def test_invalid_reset_status_blank(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": ""}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0003") > 0), "Response message is not as expected.",
        )


class TestPatchValidationVal0004(unittest.TestCase):
    "Tests for the VAL-0004 validation code for the Patch endpoint"

    def test_invalid_reset_status_in_given_too_low(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": -1}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0), "Response message is not as expected.",
        )

    def test_invalid_reset_status_in_given_too_high(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": 2345}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0), "Response message is not as expected.",
        )


class TestPatchValidationVal0005(unittest.TestCase):
    "Tests for the VAL-0005 validation code for the Patch endpoint"

    def test_invalid_notes_greater_than_900(self):
        client = Client()

        too_many_notes = TestEnv.max_notes + "a"

        data = (
            '{"capacityStatus":"red",\
            "notes":"'
            + too_many_notes
            + '"}'
        )

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0005") > 0), "Response message is not as expected.",
        )


class TestPatchValidationVal0006(unittest.TestCase):
    "Tests for the VAL-0006 validation code for the Patch endpoint"

    def test_invalid_notes_blank(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "notes":""}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0006") > 0), "Response message is not as expected.",
        )


class TestPatchValidationMultipleVals(unittest.TestCase):
    "Tests for multiple validation warnings being raised"

    def test_multiple_invalid_inputs(self):
        client = Client()

        data = '{"capacityStatus":"pink",\
            "resetStatusIn":-1,\
            "notes":""}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        self.assertEqual(response.status_code, 400, "Response status code is not as expected.")

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0), "Response message is not as expected, no VAL-0002.",
        )

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0), "Response message is not as expected, no VAL-0004.",
        )

        self.assertTrue(
            (str(response.content).find("VAL-0006") > 0), "Response message is not as expected, no VAL-0006.",
        )
