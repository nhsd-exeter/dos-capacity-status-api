validation_rules = {
    1: {
        "name": "VAL-0001",
        "desc": "<B> VAL-0001</B> - A Capacity Status (capacityStatus) has not been given - returned when no Capacity Status is given.",
        "error_msg": "VAL-0001 - A Capacity Status (capacityStatus) has not been given.",
    },
    2: {
        "name": "VAL-0002",
        "desc": "<B> VAL-0002</B> - Invalid CapacityStatus value - returned when a capacity status other than that defined by the CapacityStatusRequestPayload model \
is given.",
        "error_msg": "VAL-0002 - The given CapacityStatus value is invalid and must be a value as defined by the CapacityStatusRequestPayload model.",
    },
    3: {
        "name": "VAL-0003",
        "desc": "<B> VAL-0003</B> - Invalid ResetStatusIn value - returned when a reset time other than that defined by the CapacityStatusRequestPayload model is \
given.",
        "error_msg": "VAL-0003 - The given ResetStatusIn is invalid and must an Integer value within the range defined by the CapacityStatusRequestPayload model.",
    },
    4: {
        "name": "VAL-0004",
        "desc": "<B> VAL-0004</B> - ResetStatusIn outside of limits - returned when the reset time given is outside of the minimum or maximum limits \
            defined by the CapacityStatusRequestPayload model.",
        "error_msg_min_value": "VAL-0004 - ResetStatusIn outside of limits - the reset time given is outside the minimum limit \
(%(limit_value)s minutes) defined by the CapacityStatusRequestPayload model.",
        "error_msg_max_value": "VAL-0004 - ResetStatusIn outside of limits - the reset time given is outside the maximum limit \
(%(limit_value)s minutes) defined by the CapacityStatusRequestPayload model.",
    },
    5: {
        "name": "VAL-0005",
        "desc": "<B> VAL-0005</B> - Notes outside of limits - returned when the notes given are outside of the maximum limit defined by the \
            CapacityStatusRequestPayload model.",
        "error_msg": "VAL-0005 - Given notes are outside of the maximum character limit (%(limit_value)s characters) as defined by the CapacityStatusRequestPayload model.",
    },
}
