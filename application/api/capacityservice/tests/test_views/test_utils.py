from django.test import Client
from django.core.exceptions import ObjectDoesNotExist

from ....capacityauth.models import DosUserAPIKey


class TestUtils:
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

    client = Client()

    def call_put_with_payload(self, payload):
        return self.client.put(
            self.api_url,
            content_type="application/json",
            data=payload,
            HTTP_HOST="127.0.0.1",
            **self.auth_headers,
        )

