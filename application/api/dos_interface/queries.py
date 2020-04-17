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
        )
        select id from service_ancestry)
    );"""

get_service_info_sql = """
    SELECT
        s.id,
        s.name,
        s.typeid,
        s.parentid,
        sc.notes,
        sc.modifiedby,
        sc.modifieddate,
        sc.resetdatetime,
        cs.color
    FROM services s
    JOIN servicecapacities sc ON sc.serviceid = s.id
    JOIN capacitystatuses cs ON cs.capacitystatusid = sc.capacitystatusid
    WHERE s.id IN (
    WITH RECURSIVE service_ancestry AS (
            SELECT s.id, s.parentid FROM services s
            WHERE s.uid = %s
            UNION
            SELECT s.id, s.parentid FROM services s
            JOIN service_ancestry d on d.parentid = s.id
        )
	SELECT id FROM service_ancestry
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

def get_service_info(service_uid, throwDoesNotExist=True):
    with connections["dos"].cursor() as cursor:

        cursor.execute(get_service_info_sql, [service_uid])
        row = dictfetchall(cursor)

    return row[0], row[-1]

def dictfetchall(cursor):
    "Return all rows from a cursor as a dict"
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]
