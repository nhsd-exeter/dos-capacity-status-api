validation_rules = {
    1: {
        "name": "VAL-0001",
        "desc": "<B> VAL-0001</B> - ServiceIdentifier must be provided - returned when no ServiceIdentifer has been specified.",
        "error_msg": "VAL-0001 - A CapacityStatus had not been specified.",
    },
    2: {
        "name": "VAL-0002",
        "desc": "<B> VAL-0002</B> - Invalid Servicestatus value - returned when a service status other than that defined by the Service Update Model \
is specified.",
        "error_msg": "VAL-0002 - The given CapacityStatus value is invalid and must be a value as defined in the payload model.",
    },
    3: {
        "name": "VAL-0003",
        "desc": "<B> VAL-0003</B> - Invalid ResetStatusIn value - returned when a reset time other than that defined by the Service Update Model is \
specified.",
        "error_msg": "VAL-0003 - The given ResetStatusIn is invalid and must an Integer value as define in the payload model.",
    },
    4: {
        "name": "VAL-0004",
        "desc": "<B> VAL-0004</B> - ResetStatusIn outside of limits - returned when the reset time specified is outside of the minimum or maximum limits \
            defined by the Service Update Model.",
        "error_msg_min_value": "VAL-0004 - ResetStatusIn outside of limits - returned as the reset time specified is outside the minimum limit \
(%(limit_value)s minutes) defined by the Service Update Model.",
        "error_msg_max_value": "VAL-0004 - ResetStatusIn outside of limits - returned as the reset time specified is outside of the maximum limit \
(%(limit_value)s minutes) defined by the Service Update Model.",
    },
    5: {
        "name": "VAL-0005",
        "desc": "<B> VAL-0005</B> - Notes outside of limits - returned when the notes specified are outside of the maximum limit defined by the Service \
Update Model.",
        "error_msg": "VAL-0005 - Specified Notes are outside of the maximum character limit (%(limit_value)s characters) as defined in the payload model.",
    },
}
