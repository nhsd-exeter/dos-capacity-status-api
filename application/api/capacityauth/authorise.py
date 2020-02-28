from django.core.exceptions import ObjectDoesNotExist
from api.dos.queries import can_user_edit_service, get_dos_user_for_user_id


def can_dos_user_api_key_edit_service(dos_user_api_key, service_uid):
    return can_user_edit_service(dos_user_api_key.dos_user_id, service_uid)


def get_user_for_key(dos_user_api_key):
    try:
        return get_dos_user_for_user_id(dos_user_api_key.dos_user_id)
    except ObjectDoesNotExist:
        return None
