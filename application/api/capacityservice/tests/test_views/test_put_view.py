import unittest
import json
from django.test import Client

from django.core.exceptions import ObjectDoesNotExist

from ....capacityauth.models import DosUserAPIKey


class TestPutView(unittest.TestCase):
    "Tests for the PUT view"

    api_url = "/api/v0.0.1/capacity/services/149198/capacitystatus/"
    api_no_service_url = "/api/v0.0.1/capacity/services/1491981234/capacitystatus/"

    api_key = None
    auth_headers = None

    key = None
    try:
        key = (
            DosUserAPIKey.objects.db_manager("default")
            .filter(dos_username__contains="TestUser")
            .delete()
        )
    except ObjectDoesNotExist:
        pass
    finally:
        key = DosUserAPIKey.objects.db_manager("default").create_key(
            dos_username="TestUser"
        )

    api_key = key[1]
    auth_headers = {
        "HTTP_AUTHORIZATION": "Api-Key " + api_key,
    }

    def test_unauthorised_user_no_creds(self):
        client = Client()

        response = client.put(self.api_url)

        self.assertEqual(
            response.status_code, 403, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content,
            b'{"detail":"Authentication credentials were not provided."}',
            "Response status code is not as expected.",
        )

    def test_no_service_found(self):
        client = Client()
        response = client.put(
            self.api_no_service_url, HTTP_HOST="127.0.0.1", **self.auth_headers
        )

        self.assertEqual(
            response.status_code, 404, "Response status code is not as expected."
        )
        self.assertEqual(
            response.content, b'"Given service does not exist"',
        )

    """ def test_invalid_capacity_status_given_number(self):
        client = Client()

        data = '{"capacityStatus":30}'

        response = client.put(
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        ) """

    def test_invalid_capacity_status_given_text(self):
        client = Client()

        data = '{"capacityStatus":"PINK"}'

        response = client.put(
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

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
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        )

    def test_invalid_reset_status_in_given_too_low(self):
        client = Client()

        data = '{"capacityStatus":"red",\
            "resetStatusIn": -1}'

        response = client.put(
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

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
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0004") > 0),
            "Response message is not as expected.",
        )


"""     def test_invalid_capacity_status_given_none(self):
        client = Client()

        data = '{"capacityStatus":}'

        response = client.put(
            self.api_url,
            content_type="application/json",
            data=data,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

        json_response = json.loads(str(response.content, encoding="utf8"))

        self.assertEqual(
            response.status_code, 400, "Response status code is not as expected."
        )

        self.assertTrue(
            (str(response.content).find("VAL-0002") > 0),
            "Response message is not as expected.",
        ) """

