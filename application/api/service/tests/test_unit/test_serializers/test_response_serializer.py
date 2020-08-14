import unittest
from ....serializers.response_serializer import CapacityStatusResponseSerializer


class TestCapacityStatusResponseSerializer(unittest.TestCase):
    "Tests for the CapacityStatusResponseSerializer class"

    def test_response_serializer__success(self):
        "Test successful convert model to response function"
        data = {
            "id": 2668,
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "modifiedby": "TestUser",
            "modifieddate": "2020-08-10T11:09:38Z",
            "service": {
                "id": 2668,
                "uid": "149198",
                "name": "Dentist - Castle View Dental Practice, Dudley",
                "publicname": "None",
            },
            "resetdatetime": "2020-08-10T15:09:38Z",
            "status": {"color": "GREEN"},
        }
        response = CapacityStatusResponseSerializer.convertModelToResponse(data)
        expected = {
            "id": "149198",
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "status": "GREEN",
            "name": "Dentist - Castle View Dental Practice, Dudley",
            "resetDateTime": "2020-08-10T15:09:38Z",
            "modifiedBy": "TestUser",
            "modifiedDate": "2020-08-10T11:09:38Z",
        }
        self.assertEqual(response, expected)

    def test_response_serializer_when_notes_are_empty(self):
        "Test successful convert model to response function when no notes are present"
        data = {
            "id": 2668,
            "notes": None,
            "modifiedbyid": 1000000002,
            "modifiedby": "TestUser",
            "modifieddate": "2020-08-10T11:09:38Z",
            "service": {
                "id": 2668,
                "uid": "149198",
                "name": "Dentist - Castle View Dental Practice, Dudley",
                "publicname": "None",
            },
            "resetdatetime": "2020-08-10T15:09:38Z",
            "status": {"color": "GREEN"},
        }
        response = CapacityStatusResponseSerializer.convertModelToResponse(data)
        expected = {
            "id": "149198",
            "modifiedbyid": 1000000002,
            "status": "GREEN",
            "name": "Dentist - Castle View Dental Practice, Dudley",
            "resetDateTime": "2020-08-10T15:09:38Z",
            "modifiedBy": "TestUser",
            "modifiedDate": "2020-08-10T11:09:38Z",
        }
        self.assertEqual(response, expected)

    def test_response_serializer_when_modifieddate_is_empty(self):
        "Test successful convert model to response function when modifieddate field is None"
        data = {
            "id": 2668,
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "modifiedby": "TestUser",
            "modifieddate": None,
            "service": {
                "id": 2668,
                "uid": "149198",
                "name": "Dentist - Castle View Dental Practice, Dudley",
                "publicname": "None",
            },
            "resetdatetime": "2020-08-10T15:09:38Z",
            "status": {"color": "GREEN"},
        }
        response = CapacityStatusResponseSerializer.convertModelToResponse(data)
        expected = {
            "id": "149198",
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "status": "GREEN",
            "name": "Dentist - Castle View Dental Practice, Dudley",
            "resetDateTime": "2020-08-10T15:09:38Z",
            "modifiedBy": "TestUser",
        }
        self.assertEqual(response, expected)

    def test_response_serializer_when_resetdatetime_is_empty(self):
        "Test successful convert model to response function when resetdatetime field is None"
        data = {
            "id": 2668,
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "modifiedby": "TestUser",
            "modifieddate": "2020-08-10T11:09:38Z",
            "service": {
                "id": 2668,
                "uid": "149198",
                "name": "Dentist - Castle View Dental Practice, Dudley",
                "publicname": "None",
            },
            "resetdatetime": None,
            "status": {"color": "GREEN"},
        }
        response = CapacityStatusResponseSerializer.convertModelToResponse(data)
        expected = {
            "id": "149198",
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "status": "GREEN",
            "name": "Dentist - Castle View Dental Practice, Dudley",
            "modifiedBy": "TestUser",
            "modifiedDate": "2020-08-10T11:09:38Z",
        }
        self.assertEqual(response, expected)

    def test_response_serializer_when_modifiedby_is_empty(self):
        "Test successful convert model to response function when modifiedby field is None"
        data = {
            "id": 2668,
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "modifiedby": None,
            "modifieddate": "2020-08-10T11:09:38Z",
            "service": {
                "id": 2668,
                "uid": "149198",
                "name": "Dentist - Castle View Dental Practice, Dudley",
                "publicname": "None",
            },
            "resetdatetime": "2020-08-10T15:09:38Z",
            "status": {"color": "GREEN"},
        }
        response = CapacityStatusResponseSerializer.convertModelToResponse(data)
        expected = {
            "id": "149198",
            "notes": "Capacity status set by Capacity Status API - some more notes",
            "modifiedbyid": 1000000002,
            "status": "GREEN",
            "name": "Dentist - Castle View Dental Practice, Dudley",
            "resetDateTime": "2020-08-10T15:09:38Z",
            "modifiedDate": "2020-08-10T11:09:38Z",
        }
        self.assertEqual(response, expected)
