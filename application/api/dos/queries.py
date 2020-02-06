from django.db import connections

sql_temp_01 = "SELECT EXISTS(SELECT s from services s where s.uid = %s)"
sql_temp_02 = "SELECT EXISTS(SELECT u from users u \
    join userpermissions up on up.userid = u.id \
    join userservices us on us.userid = u.id \
    join services s on s.id = us.serviceid \
    where u.id = %s and up.permissionid = 3 and s.uid = %s)"
can_user_edit_service_sql = """SELECT EXISTS(SELECT u FROM users u
    JOIN userpermissions up ON up.userid = u.id
    JOIN userservices us ON us.userid = u.id
    JOIN services s ON s.id = us.serviceid
    WHERE u.id = %s AND up.permissionid = 3 AND  us.serviceid in (
        WITH RECURSIVE user_accessible_services AS (
            select s.id, s.uid, s.parentid from services s
            where s.uid = %s
            union
            select s.id, s.uid, s.parentid from services s
            join user_accessible_services d on d.parentid = s.id
        )
        select id from user_accessible_services)
    );"""


def can_user_edit_service(userid, service_uid):
    with connections["dos"].cursor() as cursor:

        cursor.execute(can_user_edit_service_sql, [userid, service_uid])
        row = cursor.fetchone()

    return row[0]
