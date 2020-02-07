from django.db import connections


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


def can_user_edit_service(userid, service_uid):
    with connections["dos"].cursor() as cursor:

        cursor.execute(can_user_edit_service_sql, [userid, service_uid])
        row = cursor.fetchone()

    return row[0]
