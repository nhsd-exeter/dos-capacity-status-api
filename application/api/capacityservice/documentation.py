from .validation import validation_rules
from drf_yasg import openapi

capacity_service_api_desc = "This is the Capacity Service API. </BR> \
    </BR> \
    The API will enable UEC service providers and DoS Leads to change the RAG status \
    (also known as the Capacity Status) of their active services in DoS by means of a collection \
    of restful endpoints that can be called from third party systems. </BR> \
    Upon successful retrieval or update of capacity information, this API will respond \
    with the current (updated) capacity information for the active service. All required fields \
    will be returned, but optional fields will not be returned in the cases where no \
    data is present for them. For example, if there is no reset date/time for an active service \
    (in the cases where active services are in a GREEN capacity state) the reset date/time field \
    will not be included in the response. Refer to the endpoint specifications below for \
    API response details. </BR> \
    </BR> \
    <B>API Authentication</B></BR> \
    </BR> \
    The API is protected by means of an API Key authentication mechanism. Clients interested \
    in using the API will need to obtain an API Key from NHSD, and this key will need to be \
    sent through as part of the request in the call to the API endpoints. </BR> \
    As part of the API Key creation process, clients will be required to specify a valid and active DoS \
    user account (username) that the API Key will be associated with. This will be used for \
    the API's authorisation process (see below). </BR> \
    </BR> \
    <B>API Authorisation</B></BR> \
    </BR> \
    The endpoints provided by this API that update service capacity information are additionally \
    protected by an authorisation mechanism which confirms that the DoS user, associated with the \
    API Key, has the correct permissions configured in DoS to be able to update the target service."


response_entities_desc = {
    "rag_status": "<li><B>RAG status</B> - this is the capacity status of the service, and will be updated to the service status defined \
        in the request payload. The API will allow an authenticated and authorised user to update the status of a service to Red, Amber, or Green.</li>",
    "reset_status_in": "<li><B>Reset status in</B> - this is the time when the service will go back into a Green status having been set to either \
        Amber or Red by the request. The reset time will be set to the date and time when the service status is updated (or maintained) plus the amount \
        of time in minutes as defined by the reset time value in the request payload. If this value is 0 or not provided, the reset time will default to \
        4 hours from the time the service status is updated. A status change to Red or Amber for a service will persist for a maximum period of 24 hours \
        per request before automatically being reset back to Green. This means that if a service needs to be Red or Amber for over 24 hours, multiple \
        requests through this API for that service will be required. </li>",
    "notes": "<li><B>Notes</B> - a free text field providing the opportunity for any additional ad-hoc notes to be added regarding the status change. \
        Notes defined in the request payload will be appended to the text: RAG status set by the Capacity Service API -. </li>",
    "last_updated": "<li><B>Last updated date/time</B> - this is a timestamp of when the service was last updated and will be set to the date and time \
        that the service was updated. </li>",
    "by": "<li><B>By</B> - this is a record of who last updated the service, and will be updated to the user identifier for the user that posted the \
        request to the API.</li>",
}
description_model = {
    "post__firstline": "This endpoint will update the capacity (RAG) status of a single service in DoS as specified in the request body JSON payload. \
        The format of the JSON payload is described further down in this document.",
    "business_logic_header": "</BR></BR> <B><U>Business Logic</B></U></BR></BR>",
    "request_validation_header": "</BR> </BR> <B><U>Request Validation</B></U></BR></BR>",
    "post__business_logic_content": "Upon processing a successful request, the API will return the success response (see below for the format of the \
        success response) and will update DoS with the following information: </BR> <ul>"
    + response_entities_desc["rag_status"]
    + response_entities_desc["reset_status_in"]
    + response_entities_desc["notes"]
    + response_entities_desc["last_updated"]
    + response_entities_desc["by"]
    + "</ul></BR> Requests that fail the request validation rules will not be processed and will return the validation error response (see below for \
        the validation rules and the format of the validation error response). </BR></BR> Requests that fail to be processed due to an error or failure \
        will return an error response (see below for the format of the error response)",
    "get__firstline": "This endpoint will return capacity status information for the service specified for an authenticated user.",
    "get__business_logic_content": "Upon processing a successful request, the API will return the success service status response (see below for the format \
        of this response.) </BR> Requests that fail the request validation rules will not be processed and will return the validation error response (see \
        below for the validation rules and the format of the validation error response). </BR></BR> Requests that fail to be processed due to an error or \
        failure will return an error response (see below for the format of the error response)",
}
description_post = (
    description_model["post__firstline"]
    + description_model["business_logic_header"]
    + description_model["post__business_logic_content"]
    + description_model["request_validation_header"]
    + "Values specified in the request payload will be validated by the API. The following business validation rules are in place: </BR><ul>"
    + "<li>"
    + validation_rules[1]["desc"]
    + "</li><li>"
    + validation_rules[2]["desc"]
    + "</li><li>"
    + validation_rules[3]["desc"]
    + "</li><li>"
    + validation_rules[4]["desc"]
    + "</li><li>"
    + validation_rules[5]["desc"]
    + "</li></ul> </BR> <B><U>Response Formats</B></U></BR> </BR> Please refer to the Response section of this document for the response formats."
)
description_get = (
    description_model["get__firstline"]
    + description_model["business_logic_header"]
    + description_model["get__business_logic_content"]
)

service_uid_path_param = openapi.Parameter(
    "service__uid",
    in_="path",
    description="The UID which identifies the service",
    type=openapi.TYPE_STRING,
)
