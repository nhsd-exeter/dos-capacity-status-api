from django.core.exceptions import ObjectDoesNotExist
from api.dos_interface.queries import get_service_info

from datetime import datetime
from time import gmtime, strftime

import logging

usage_reporting_logger = logging.getLogger("api.usage.reporting")


def _get_service_info(service_uid):
    try:
        service_info, dos_region_info = get_service_info(service_uid)
        return service_info, dos_region_info
    except ObjectDoesNotExist:
        return None


def _retrieve_service_data(service_uid):

    service_info, dos_region_info = _get_service_info(service_uid)

    service_data = {"CLIENT_NAME": service_info["modifiedby"]}
    service_data["ORG_NAME"] = "org_name=" + service_info["name"]
    service_data["DOS_REGION"] = "dosregion=" + dos_region_info["name"]
    service_data["PARENT_ORG"] = "parentorg=" + str(service_info["parentid"])
    service_data["ORG_TYPE"] = "org_type=" + str(service_info["typeid"])
    service_data["CAPACITY_STATUS"] = "capacity=" + service_info["color"]
    service_data["NOTES"] = "notes=" + service_info["notes"]

    reset_date_time = ""
    if service_info["resetdatetime"] is not None:
        reset_date_time = service_info["resetdatetime"].strftime("%d-%m-%Y %H:%M")
    service_data["RESET_DATE_TIME"] = "resetdatetime=" + reset_date_time

    changed_time = ""
    if service_info["modifieddate"] is not None:
        changed_time = service_info["modifieddate"].strftime("%d-%m-%Y %H:%M")
    service_data["CHANGED_TIME"] = "changedtime=" + changed_time

    return service_data


def _get_request_execution_time(request):
    request_received = datetime.fromisoformat(request.META["HTTP_X_REQUEST_RECEIVED"])
    return (datetime.now() - request_received).total_seconds()


def log_reporting_info(service_uid, request, action="saveCapacityStatus", status="success"):

    report_data = {"ORG_ID": "org_id=" + str(service_uid)}
    report_data["REQUEST_ID"] = request.META["HTTP_X_REQUEST_ID"]
    report_data["CLIENT_IP"] = request.META["HTTP_X_CLIENT_IP"]
    report_data.update(_retrieve_service_data(service_uid))

    execution_time = "execution_time=" + str(_get_request_execution_time(request))

    message = (
        strftime("%Y/%m/%d %H:%M:%S.000000%z", gmtime())
        + "|info|update|"
        + report_data["REQUEST_ID"]
        + "|"
        + report_data["CLIENT_IP"]
        + "|"
        + report_data["CLIENT_NAME"]
        + "|"
        + action
        + "|request|"
        + status
        + "|"
        + report_data["ORG_ID"]
        + "|"
        + report_data["ORG_NAME"]
        + "|"
        + report_data["DOS_REGION"]
        + "|"
        + report_data["PARENT_ORG"]
        + "|"
        + report_data["ORG_TYPE"]
        + "|"
        + report_data["CAPACITY_STATUS"]
        + "|"
        + report_data["NOTES"]
        + "|"
        + report_data["RESET_DATE_TIME"]
        + "|"
        + report_data["CHANGED_TIME"]
        + "|"
        + execution_time
    )
    usage_reporting_logger.info("%s", message)
