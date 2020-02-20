from api.dos.queries import can_user_edit_service

def can_dos_user_api_key_edit_service(dos_user_api_key, service_uid):
    return can_user_edit_service(dos_user_api_key.dos_user_id, service_uid)
