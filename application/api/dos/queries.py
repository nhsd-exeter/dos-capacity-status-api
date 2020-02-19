from django.db import connections
from .models import Users


can_user_edit_service_sql = """SELECT EXISTS(SELECT 1 FROM users u
    JOIN userpermissions up ON up.userid = u.id
    JOIN userservices us ON us.userid = u.id
    JOIN services s ON s.id = us.serviceid
    WHERE u.id = %s AND up.permissionid = 3 AND  us.serviceid in (
        WITH RECURSIVE service_ancestry AS (
            select s.id, s.parentid from services s
            where s.uid = %s
            union
            select s.id, s.parentid from services s
            join service_ancestry d on d.parentid = s.id
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