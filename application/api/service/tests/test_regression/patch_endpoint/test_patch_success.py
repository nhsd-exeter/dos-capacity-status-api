import unittest
import json

from django.test import Client, tag
from ..test_env import TestEnv
from ..test_helper import TestHelper

test_helper = TestHelper()
client = Client()


@tag("regression")
class TestPatchSuccess(unittest.TestCase):
    "Tests for the successful update of capacity status information"

    def test_update_capacity_status_red(self):

        data = '{"status":"red"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response)

    def test_update_capacity_status_amber(self):

        data = '{"status":"amber"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, capacity_status="AMBER")

    def test_update_capacity_status_amber_full(self):

        data = '{"status":"amber", "resetStatusIn":50, "notes":"some more notes"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(
            json_response,
            capacity_status="AMBER",
            reset_status_in=50,
            notes="Capacity status set by Capacity Status API - some more notes",
        )

    def test_update_capacity_status_green(self):

        data = '{"status":"GreEn"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, capacity_status="GREEN", expected_reset_date_time=False)

    def test_update_capacity_status_green_full(self):

        data = '{"status":"green", "resetStatusIn":50, "notes":"some more notes"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )
        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(
            json_response,
            capacity_status="GREEN",
            expected_reset_date_time=False,
            notes="Capacity status set by Capacity Status API - some more notes",
        )

    def test_update_capacity_reset_time_0(self):

        data = '{"status":"ReD", "resetStatusIn":0}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, reset_status_in=0)

    def test_update_capacity_reset_time_30(self):

        data = '{"status":"red", "resetStatusIn":30}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, reset_status_in=30)

    def test_update_capacity_reset_time_1440(self):

        data = '{"status":"rEd", "resetStatusIn":1440}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, reset_status_in=1440)

    def test_update_capacity_additional_notes_int(self):

        data = '{"status":"reD", "notes":1234}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(json_response, notes="Capacity status set by Capacity Status API - 1234")

    def test_update_capacity_additional_notes_text(self):

        data = '{"status":"rEd", "resetStatusIn":50, "notes":"some more notes"}'

        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(
            json_response, reset_status_in=50, notes="Capacity status set by Capacity Status API - some more notes",
        )

    def test_update_capacity_additional_notes_loads(self):

        data = '{"status":"reD","notes":"' + TestEnv.max_notes + '"}'
        response = client.patch(
            TestEnv.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST=TestEnv.api_host,
            **TestEnv.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(response.status_code, 200, "Response status code is not as expected.")

        test_helper.check_response(
            json_response, notes="Capacity status set by Capacity Status API - " + TestEnv.max_notes,
        )
