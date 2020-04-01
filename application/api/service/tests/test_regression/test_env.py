from django.core.exceptions import ObjectDoesNotExist
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from datetime import datetime, timedelta

from ....authentication.models import DosUserAPIKey


class TestEnv:
    api_host = "localhost"
    api_url = "/api/v0.0.1/capacity/services/149198/capacitystatus/"
    api_no_service_url = "/api/v0.0.1/capacity/services/1491981234/capacitystatus/"
    api_inactive_service_url = "/api/v0.0.1/capacity/services/133102/capacitystatus/"
    api_unauthorised_url = "/api/v0.0.1/capacity/services/110798/capacitystatus/"

    token_key = None
    auth_headers = None
    key = None
    inactive_key = None
    try:
        user = (
            User.objects.db_manager("default")
            .filter(username__contains="TestUser")
            .delete()
        )
    except ObjectDoesNotExist:
        pass
    finally:

        user = User.objects.db_manager("default").create_user(
            username="TestUser", password="fakePassword1"
        )
        ca_dos_user = CapacityAuthDosUser.objects.db_manager("default").create(
            dos_username="TestUser", dos_user_id=1000000002, user=user
        )
        token = Token.objects.db_manager("default").create(user=user)

    try:

        inactive_user = (
            User.objects.db_manager("default")
            .filter(username__contains="InActiveTestUser")
            .delete()
        )
    except ObjectDoesNotExist:
        pass
    finally:
        inactive_user = User.objects.db_manager("default").create_user(
            username="InActiveTestUser", password="fakePassword2"
        )
        ca_dos_user = CapacityAuthDosUser.objects.db_manager("default").create(
            dos_username="InActiveTestUser", dos_user_id=1000000003, user=inactive_user
        )
        inactive_token = Token.objects.db_manager("default").create(user=inactive_user)

    auth_headers = {
        "HTTP_AUTHORIZATION": "Token " + token.key,
    }
    inactive_auth_headers = {
        "HTTP_AUTHORIZATION": "Token " + inactive_token.key,
    }
    invalid_auth_headers = {
        "HTTP_AUTHORIZATION": "Token Invalid",
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

