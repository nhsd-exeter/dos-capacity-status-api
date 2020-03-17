from django.core.exceptions import ObjectDoesNotExist
from api.dos.queries import can_user_edit_service, get_dos_user_for_user_id
from .models import CapacityAuthDosUser

def get_dos_user(capacity_user):

    try:
        dos_user = CapacityAuthDosUser.objects.db_manager("default").get(user_id=capacity_user.id)
        return get_dos_user_for_user_id(dos_user.dos_user_id)
    except ObjectDoesNotExist:
        return None

def can_capacity_user_edit_service(capacity_user, service_uid):
    dos_user = get_dos_user(capacity_user)
    if dos_user is None:
        return False
    return can_user_edit_service(dos_user.id, service_uid)
