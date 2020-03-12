from .validation import validation_rules
from drf_yasg import openapi

capacity_service_api_desc = "This is the Capacity Status API. </BR> \
    </BR> \
    The API will enable UEC service providers and DoS Leads to change the Capacity Status \
    (also known as the RAG Status) of their active services in DoS by means of a collection \
    of restful endpoints that can be called from third party systems. </BR> \
    Upon successful retrieval or update of capacity information, this API will respond \
    with the current (updated) capacity information for the active service. All required fields \
    will be returned, but optional fields will not be returned in the cases where no \
    data is present for them. For example, if there is no reset date/time for an active service \
    (in the case where the active service is in a GREEN capacity state) the reset date/time field \
    will not be included in the response. Refer to the endpoint specifications below for \
    API response details. </BR> \
    All endpoints of this API require that the UID of the service to retrieve/update is given in \
    the URL. If no such active service can be found in DoS for the given UID an HTTP-404 error code \
    will be returned. </BR>\
    </BR> \
    <B>API Authentication</B></BR> \
    </BR> \
    The API is protected by means of an API Key authentication mechanism. Clients interested \
    in using the API will need to obtain an API Key from NHSD, and this key will need to be \
    sent through as part of the request in the call to the API endpoints. </BR> \
    As part of the API Key creation process, clients will be required to specify a valid and active DoS \
    user account (username) that the API Key will be associated with. This will be used for \
    the API's authorisation process. </BR> \
    </BR> \
    <B>API Authorisation</B></BR> \
    </BR> \
    The endpoints provided by this API that update service capacity information are additionally \
    protected by an authorisation mechanism which confirms that the DoS user (associated with the \
    API Key) has the correct permissions configured in DoS to be able to update the target service. \
    In the event that a DoS User does not have permissions to update the capacity status of a service, \
    an HTTP-403 error code will be returned and the capacity status information of the service will \
    not be updated."


response_entities_desc = {
    "rag_status": "<li><B>Capacity status</B> - the capacity status of the service that is updated to the capacity status given \
        in the request payload. The capacity status can be set to Red, Amber, or Green.</li>",
    "reset_status_in": "<li><B>Reset time</B> - the date and time when the service will automatically transition back to a Green capacity status having been set to either \
        Amber or Red by the request. The reset time will be set to the date and time when the capacity status is updated (or maintained) plus the amount \
        of time in minutes as defined by the resetStatusIn value given in the request payload. If this value is not provided, the reset time will default to \
        4 hours from the time the capacity status is updated. A capacity status change to Red or Amber for a service can be set to persist for a maximum period of 24 hours \
        per request before automatically being reset back to Green. This means that if a service needs to be Red or Amber for over 24 hours, multiple \
        requests through this API for that service will be required. </li>",
    "notes": "<li><B>Notes</B> - a free text field providing the opportunity for any additional notes to be logged regarding the capacity status change. \
        Notes given in the request payload will be appended to the text: Capacity status set by the Capacity Service API -. </li>",
    "last_updated": "<li><B>Last updated date/time</B> - a timestamp of when the service was updated by the API.</li>",
    "by": "<li><B>Modified by</B> - the name of the DoS User (associated with the API key) who last updated the capacity information of the service.</li>",
}
description_model = {
    "post__firstline": "This endpoint will update the capacity (RAG) status of a single service in DoS as specified in the request body JSON payload. \
        The format of the JSON payload is described further down in this document.",
    "business_logic_header": "</BR></BR> <B><U>Business Logic</B></U></BR></BR>",
    "request_validation_header": "</BR> </BR> <B><U>Request Validation</B></U></BR></BR>",
    "post__business_logic_content": "Upon processing a successful request, the API will return a success \
        response containing the capacity status information for the given service and will update DoS with \
        the following information: </BR> <ul>"
    + response_entities_desc["rag_status"]
    + response_entities_desc["reset_status_in"]
    + response_entities_desc["notes"]
    + response_entities_desc["last_updated"]
    + response_entities_desc["by"]
    + "</ul></BR> Requests that fail the request validation rules will not be processed and will return a validation error response (see below for \
        the validation rules). </BR></BR> Requests that fail to be processed due to an error or failure \
        will return an error response. The format of the responses are defined below",
    "get__firstline": "This endpoint will return capacity status information for the service specified for an authenticated and authorised user.",
    "get__business_logic_content": "Upon processing a successful request, the API will return a success response \
        containing the capacity status information of the given service. </BR> \
        Requests that fail to be processed due to an error or \
        failure will return an error response. The format of the responses are defined below.",
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
    + "</li><li>"
    + validation_rules[6]["desc"]
    + "</li></ul> </BR> <B><U>Response Formats</B></U></BR> </BR> Please refer to the Response section of this document for the response formats."
)
description_get = (
    "This endpoint will return capacity status information for the service specified for an authenticated user."
    + description_model["business_logic_header"]
    + description_model["get__business_logic_content"]
)

service_uid_path_param = openapi.Parameter(
    "service__uid",
    in_="path",
    description="The service UID identifying the service to retrieve/update its capacity status information.",
    type=openapi.TYPE_STRING,
)

validation_error_response = 'Bad Request - when the request fails one or more validation rules specified by the API. \
                Validation errors are grouped together by request payload field. An example validation error \
                response for an invalid capacity status and reset status in value would therefore look like: </BR>\
<pre>{ </BR>\
    "capacityStatus": [</BR>\
        "VAL-0002 - The given CapacityStatus value is invalid and must be a value as defined by the CapacityStatusRequestPayload model." </BR>\
    ],</BR>\
    "resetStatusIn": [</BR>\
        "VAL-0004 - ResetStatusIn outside of limits - the reset time given is outside the minimum limit (0 minutes) defined by the CapacityStatusRequestPayload model."</BR>\
    ]</BR>\
}</pre>'

authentication_error_response = 'Unauthorized - when a user is either no longer active in DoS or is not authenticated to use this API. \
                An authentication error response would look like: </BR>\
<pre>{</BR>\
    "detail": "Authentication credentials were not provided."<BR>\
}'
