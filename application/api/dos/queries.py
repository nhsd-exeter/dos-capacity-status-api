from django.db import connections
from django.core.exceptions import ObjectDoesNotExist
from .models import Users, Services

# presumes active services only (statusid 1) for a user with 'Active' status
can_user_edit_service_sql = """SELECT EXISTS(SELECT 1 FROM users u
    JOIN userpermissions up ON up.userid = u.id
    JOIN userservices us ON us.userid = u.id
    JOIN services s ON s.id = us.serviceid
    WHERE u.id = %s AND u.status = 'ACTIVE' AND up.permissionid = 3 AND  us.serviceid in (
        WITH RECURSIVE service_ancestry AS (
            select s.id, s.parentid from services s
            where s.uid = %s AND s.statusid = 1
            union
            select s.id, s.parentid from services s
            join service_ancestry d on d.parentid = s.id
            where s.statusid = 1
        )
        select id from service_ancestry)
    );"""


def can_user_edit_service(dos_user_id, service_uid):
    with connections["dos"].cursor() as cursor:

        cursor.execute(can_user_edit_service_sql, [dos_user_id, service_uid])
        row = cursor.fetchone()

    return row[0]


def get_dos_user_for_username(dos_username):
    return Users.objects.db_manager("dos").get(username=dos_username)


def get_dos_user_for_user_id(dos_user_id):
    return Users.objects.db_manager("dos").get(id=dos_user_id)


def get_dos_service_for_uid(service_uid, throwDoesNotExist=True):
    if throwDoesNotExist:
        return Services.objects.db_manager("dos").get(uid=service_uid)
    else:
        try:
            return Services.objects.db_manager("dos").get(uid=service_uid)
        except ObjectDoesNotExist:
            return None

