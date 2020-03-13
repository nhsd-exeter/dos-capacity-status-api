from django.core.exceptions import ObjectDoesNotExist
from datetime import datetime, timedelta

from ....capacityauth.models import DosUserAPIKey


class TestEnv:
    api_url = "/api/v0.0.1/capacity/services/149198/capacitystatus/"
    api_no_service_url = "/api/v0.0.1/capacity/services/1491981234/capacitystatus/"
    api_inactive_service_url = "/api/v0.0.1/capacity/services/133102/capacitystatus/"
    api_unauthorised_url = "/api/v0.0.1/capacity/services/110798/capacitystatus/"
    api_key = None
    auth_headers = None
    key = None
    inactive_key = None
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

    try:
        inactive_key = (
            DosUserAPIKey.objects.db_manager("default")
            .filter(dos_username__contains="InActiveTestUser")
            .delete()
        )
    except ObjectDoesNotExist:
        pass
    finally:
        inactive_key = DosUserAPIKey.objects.db_manager("default").create_key(
            dos_username="InActiveTestUser"
        )

    api_key = key[1]
    auth_headers = {
        "HTTP_AUTHORIZATION": "Api-Key " + api_key,
    }
    inactive_api_key = inactive_key[1]
    inactive_auth_headers = {
        "HTTP_AUTHORIZATION": "Api-Key " + inactive_api_key,
    }
    invalid_auth_headers = {
        "HTTP_AUTHORIZATION": "Api-Key Invalid",
    }

    current_time = datetime.now()
    expected_reset_time_upper = (
        current_time + timedelta(minutes=240) + timedelta(minutes=10)
    )
    expected_reset_time_str_upper = expected_reset_time_upper.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )
    expected_reset_time_lower = (
        current_time + timedelta(minutes=240) - timedelta(minutes=10)
    )
    expected_reset_time_str_lower = expected_reset_time_lower.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )

    expected_reset_time_zero_upper = current_time + timedelta(minutes=10)
    expected_reset_time_str_upper = expected_reset_time_upper.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )
    expected_reset_time_lower = (
        current_time + timedelta(minutes=240) - timedelta(minutes=10)
    )
    expected_reset_time_str_lower = expected_reset_time_lower.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )

    expected_modified_time_upper = current_time + timedelta(minutes=10)
    expected_modified_time_str_upper = expected_modified_time_upper.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )
    expected_modified_time_lower = current_time
    expected_modified_time_str_lower = expected_modified_time_lower.astimezone().strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    )

    max_notes = "avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshy\
avfsgtysyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfsgtyshyavfs\
hyavfsgtyshyavfsgtysswdabbbbbbbcba"

