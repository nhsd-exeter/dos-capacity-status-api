from django.core.exceptions import ObjectDoesNotExist
from api.dos_interface.queries import get_service_info

from datetime import datetime, timedelta
from time import gmtime, strftime

import logging

usage_metrics_logger = logging.getLogger('api.usage.metrics')

def _get_service_info(service_uid):
    try:
        service_info = get_service_info(service_uid)
        return service_info
    except ObjectDoesNotExist:
        return None

def _build_usage_message(request, service_uid,  status, request_initiation_time, action):

    service_info, dos_region_info = _get_service_info(service_uid)

    client_ip = request.META["HTTP_X_CLIENT_IP"]
    client_name = service_info["modifiedby"]
    status = status   # success or failure ?????
    org_id = 'org_id=' + str(service_uid)
    org_name = 'org_name='  + service_info["name"]
    dos_region = 'dosregion=' + dos_region_info["name"]
    parent_org = 'parentorg=' + str(service_info["parentid"])
    org_type = 'org_type=' + str(service_info["typeid"])
    capacity = 'capacity=' + service_info["color"]
    notes = 'notes=' + service_info["notes"]
    reset_date_time = 'resetdatetime=' + str(service_info["resetdatetime"])
    changed_time = 'changedtime=' + str(service_info["modifieddate"])

    request_received = datetime.fromisoformat(request.META["HTTP_X_REQUEST_RECEIVED"])
    time_now = datetime.now()

    execution_time = 'execution_time=' + str((time_now - request_received).total_seconds())



    message = strftime('%Y/%m/%d %H:%M:%S.%f%z', gmtime()) + "|info|update|" + request.META["HTTP_X_REQUEST_ID"] + "|" + client_ip + "|" + client_name + "|" + action + "|request|" + status + "|" + org_id + "|" + org_name + "|" + dos_region + "|" + parent_org + "|" + org_type + "|" + capacity + "|" + notes + "|" + reset_date_time + "|" + changed_time + "|" + execution_time

    return message

def log_reporting_info(service_uid, request, action="saveCapacityStatus", status="success", request_initiation_time='tbc'):
    message = _build_usage_message(request, str(service_uid),  status, request_initiation_time, action)
    usage_metrics_logger.info("%s", message)
