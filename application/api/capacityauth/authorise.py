from api.dos.queries import can_user_edit_service
# from .models import  ApiDosUserAssociations

# def convert_api_user_to_dos_user_id(api_user):
#     aduas = ApiDosUserAssociations.objects.filter(apiuserid=api_user.id)
#     if len(aduas) > 0:
#         return aduas[0].dosuserid
#     return None

# def can_api_user_edit_service(api_user, service):
#     # one convert api user to a dos user id
#     dos_user_id = convert_api_user_to_dos_user_id(api_user)
#     # two check against dos and return true/false
#     return can_user_edit_service(dos_user_id, service.uid)

def can_dos_user_api_key_edit_service(dos_user_api_key, service_uid):
    return can_user_edit_service(dos_user_api_key.dos_user_id, service_uid)