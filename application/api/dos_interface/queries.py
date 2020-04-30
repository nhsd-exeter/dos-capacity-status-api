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
    WITH RECURSIVE service_ancestry AS (
            SELECT s.id, s.parentid, 0 depth FROM services s
            WHERE s.uid = %s
            UNION
            SELECT s.id, s.parentid, d.depth+1 FROM services s
            JOIN service_ancestry d on d.parentid = s.id
        )
    SELECT sa.depth,
        s.id,
        s.uid,
        s.name,
        s.typeid,
        sc.notes,
        sc.modifiedby,
        sc.modifieddate,
        sc.resetdatetime,
        cs.color
    FROM service_ancestry sa
    JOIN services s ON s.id = sa.id
    JOIN servicecapacities sc ON sc.serviceid = s.id
    JOIN capacitystatuses cs ON cs.capacitystatusid = sc.capacitystatusid
    ORDER BY sa.depth ASC;"""


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


def get_service_info(service_uid):
    with connections["dos"].cursor() as cursor:

        cursor.execute(get_service_info_sql, [str(service_uid)])
        result_set = _fetch_all_as_list_of_dicts(cursor)

    if not result_set:
        raise ObjectDoesNotExist

    parent_row = None
    if len(result_set) > 1:
        parent_row = result_set[1]

    return result_set[0], parent_row, result_set[-1]


def _fetch_all_as_list_of_dicts(cursor):
    "Return all rows from a cursor as a list of dictionaries"
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]
