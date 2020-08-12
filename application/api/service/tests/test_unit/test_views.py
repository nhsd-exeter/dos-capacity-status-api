from unittest import TestCase, mock
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.response import Response
from ...views import CapacityStatusView, logger
from ....authentication.models import CapacityAuthDosUser
from ....dos_interface.models import Users as DosUser, ServiceCapacities, Services, Capacitystatuses


class Request:
    META = {
        "HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat(),
        "HTTP_X_REQUEST_ID": "dummy_id",
        "HTTP_X_CLIENT_IP": "0.0.0.1",
        "HTTP_HOST": "localhost",
    }
    user = None


class PutRequest(Request):
    data = None


class CapacityStatusViews(TestCase):
    "Tests for the Capacity Status Views Class"

    # def set_user(self, user_id, status="ACTIVE"):
    #     user = Users.objects.db_manager("dos").get(id=user_id)
    #     user = DosUser(uid=user_id, status=status)
    #     user.status = status
    #     user.save()

    def test_get__fail__no_user(self):
        "Test the get endpoint function, fail for none existent user"
        logger.info = mock.MagicMock()
        request = Request()
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"

        service_id = 101010
        response = CapacityStatusView().get(request, service_id)
        logger.info.assert_called_with("Request sent from host: %s", request.META["HTTP_HOST"])
        assert type(response) is Response
        assert response.status_code is status.HTTP_401_UNAUTHORIZED
        assert "Dos user does not exist" in response.data

    def test_get__fail_inactive_user(self):
        "Test the get endpoint function, fail for inactive user"
        logger.info = mock.MagicMock()
        request = Request()
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"

        service_id = 101010
        view = CapacityStatusView()
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="INACTIVE")
        response = view.get(request, service_id)
        logger.info.assert_called_with("Request sent from host: %s", request.META["HTTP_HOST"])
        assert type(response) is Response
        assert response.status_code is status.HTTP_401_UNAUTHORIZED
        msg = "Error should be for an inactive user but is for : " + response.data
        assert "Dos user does not have an active status" in response.data, msg

    def test_get__fail__no_service(self):
        "Test the get endpoint function, fail for no service"
        logger.info = mock.MagicMock()
        request = Request()
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"

        service_id = 101010
        view = CapacityStatusView()
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")
        view._get_service_capacity = mock.MagicMock()
        view._get_service_capacity.return_value = None
        view._get_service_or_none_from_capacity = mock.MagicMock()
        view._get_service_or_none_from_capacity.return_value = None
        response = view.get(request, service_id)
        logger.info.assert_called_with("Request sent from host: %s", request.META["HTTP_HOST"])
        assert type(response) is Response
        assert response.status_code is status.HTTP_404_NOT_FOUND
        error_msg = "Error should be for service not existing but it is for : " + response.data
        assert "service does not exist" in response.data, error_msg

    def test_get__fail__inactive_service(self):
        "Test the get endpoint function, fail for inactive service"
        logger.info = mock.MagicMock()
        request = Request()
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"

        service_id = 101010
        view = CapacityStatusView()
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")
        view._get_service_capacity = mock.MagicMock()
        view._get_service_capacity.return_value = None

        service = Services(uid=str(service_id), name="Test GP", statusid=0)
        view._get_service_or_none_from_capacity = mock.MagicMock()
        view._get_service_or_none_from_capacity.return_value = service
        response = view.get(request, service_id)
        logger.info.assert_called_with("Request sent from host: %s", request.META["HTTP_HOST"])
        assert type(response) is Response
        assert response.status_code is status.HTTP_404_NOT_FOUND
        error_msg = "Error should be for when service is not active but it is for : " + response.data
        assert "service does not have an active status" in response.data, error_msg

    def test_get_success(self):
        "Test the get endpoint function"
        logger.info = mock.MagicMock()
        request = Request()
        request.data = {"dummy_payload": "dummy"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"

        service_id = 101010
        view = CapacityStatusView()
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")
        service = Services(uid=str(service_id), name="Test GP", statusid=1)
        capacity_status = Capacitystatuses(color="RED")
        view._get_service_capacity = mock.MagicMock()
        view._get_service_capacity.return_value = ServiceCapacities(service=service, status=capacity_status)
        response = view.get(request, service_id)
        calls = [mock.call("Request sent from host: %s", request.META["HTTP_HOST"]), mock.call("In status retrieval")]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        assert response.status_code is status.HTTP_200_OK
        view.get_user_from_request.assert_called_once_with(request)
        view._get_service_capacity.assert_called_once_with(service_id)
        assert response.data == {"id": service_id, "name": service.name, "status": capacity_status.color}

    def test_put__fail__no_user(self):
        "Test the put endpoint function, fail for no user"
        logger.info = mock.MagicMock()
        request = PutRequest()
        request.data = {"status": "DUMMY_COLOR"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        view = CapacityStatusView()
        view._can_edit_service = mock.MagicMock()
        view._can_edit_service.return_value = False

        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        assert response.status_code is status.HTTP_401_UNAUTHORIZED
        assert "Dos user does not exist" in response.data

    def test_put__fail__inactive_user(self):
        "Test the put endpoint function, fail for inactive user"
        logger.info = mock.MagicMock()
        request = PutRequest()
        request.data = {"status": "DUMMY_COLOR"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        view = CapacityStatusView()
        view._can_edit_service = mock.MagicMock()
        view._can_edit_service.return_value = False
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="INACTIVE")

        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        msg = "Error should be for an inactive user but is for : " + response.data
        assert "Dos user does not have an active status" in response.data, msg

    def test_put__fail__no_service(self):
        "Test the put endpoint function, fail for no service"
        logger.info = mock.MagicMock()
        request = PutRequest()
        request.data = {"status": "DUMMY_COLOR"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        view = CapacityStatusView()
        view._can_edit_service = mock.MagicMock()
        view._can_edit_service.return_value = False
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")

        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        assert response.status_code is status.HTTP_404_NOT_FOUND
        error_msg = "Error should be for service not existing but it is for : " + response.data
        assert "service does not exist" in response.data, error_msg

    @mock.patch("api.service.views.get_dos_service_for_uid")
    def test_put__fail__inactive_service(self, mock_get_service):
        "Test the put endpoint function, fail for inactive service"
        logger.info = mock.MagicMock()
        request = PutRequest()
        request.data = {"status": "DUMMY_COLOR"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        view = CapacityStatusView()
        view._can_edit_service = mock.MagicMock()
        view._can_edit_service.return_value = False
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")

        service = Services(uid=str(service_id), name="Test GP", statusid=0)
        mock_get_service.return_value = service
        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)

        mock_get_service.assert_called_once_with(str(service_id), throwDoesNotExist=False)
        assert type(response) is Response
        assert response.status_code is status.HTTP_404_NOT_FOUND
        error_msg = "Error should be for when service is not active but it is for : " + response.data
        assert "service does not have an active status" in response.data, error_msg

    @mock.patch("api.service.views.get_dos_service_for_uid")
    def test_put__fail__user_lacks_authority(self, mock_get_service):
        "Test the put endpoint function, fail for user without authority"
        logger.info = mock.MagicMock()
        request = PutRequest()
        request.data = {"status": "DUMMY_COLOR"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        view = CapacityStatusView()
        view._can_edit_service = mock.MagicMock()
        view._can_edit_service.return_value = False
        view.get_user_from_request = mock.MagicMock()
        view.get_user_from_request.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")

        service = Services(uid=str(service_id), name="Test GP", statusid=1)
        mock_get_service.return_value = service
        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)

        mock_get_service.assert_called_once_with(str(service_id), throwDoesNotExist=False)
        assert type(response) is Response
        assert response.status_code is status.HTTP_403_FORBIDDEN
        error_msg = (
            "Error should be for when user doesn't have authority to access service but it is for : " + response.data
        )
        assert "DoS user does not have authority to edit the service" in response.data, error_msg

    # @mock.patch("api.service.views.get_dos_user")
    # @mock.patch("api.service.views.get_dos_service_for_uid")
    # def test_put__success(self, mock_get_service, mock_get_dos_user):
    #     "Test the put endpoint function"
    #     logger.info = mock.MagicMock()
    #     request = PutRequest()
    #     request.data = {"status": "red"}
    #     request.user = CapacityAuthDosUser()
    #     request.user.dos_user_id = 1010
    #     request.user.dos_username = "dummy_dos_user"
    #     service_id = 101010
    #     view = CapacityStatusView()
    #     view._can_edit_service = mock.MagicMock()
    #     view._can_edit_service.return_value = True
    #     mock_get_dos_user.return_value = DosUser(id=1010, username="dummy_dos_user", status="ACTIVE")

    #     service = Services(uid=str(service_id), name="Test GP", statusid=1)
    #     mock_get_service.return_value = service

    #     view.partial_update = mock.MagicMock()
    #     response = view.put(request, service_id)
    #     calls = [
    #         mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
    #         mock.call("Payload: %s", request.data),
    #     ]
    #     logger.info.assert_has_calls(calls)

    #     # mock_get_service.assert_called_once_with(str(service_id), throwDoesNotExist=False)
    #     assert type(response) is Response
    #     print(response.status_code)
    #     assert response.status_code is status.HTTP_200_OK
    #     print(response.data)
    #     # assert '' == response.data

    def test_patch__fail(self):
        "Test the patch function, fail for not being allowed"
        request = Request()
        view = CapacityStatusView()
        response = view.patch(request, "1")
        error_msg = "Error should be for Patch not allowed"
        assert response.status_code is status.HTTP_405_METHOD_NOT_ALLOWED, error_msg
        assert response.data == {"detail": 'Method "PATCH" not allowed. Please use "PUT" instead.'}, error_msg

    def test__get_service_or_none_from_capacity(self):
        "Test the _get_service_or_none_from_capacity function, fail for no service capacity"
        view = CapacityStatusView()
        response = view._get_service_or_none_from_capacity(service_capacity=None)
        assert response is None

    @mock.patch("api.service.views.ServiceCapacities.objects.db_manager")
    def test__get_service_capacity__fail__object_does_not_exist(self, mock_service_capacities_db_manager):
        "Test the _get_service_capacity function, fail for no service object"
        view = CapacityStatusView()
        mock_capacities_manager = mock.MagicMock()
        mock_service_capacities_db_manager.return_value = mock_capacities_manager
        mock_capacities_manager.get.side_effect = ObjectDoesNotExist("Error Test")
        response = view._get_service_capacity(service_uid=0)
        assert response is None

    # def test__get_service_capacity__success(self):
    #     "Test the _get_service_capacity function"
    #     self.set_user(user_id=100200300)
    #     view = CapacityStatusView()
    #     # response = view._get_service_capacity(service_uid=0)

    @mock.patch("api.service.views.datetime")
    def test__check_and_default_request_meta_data__fail__no_request_date(self, mock_datetime):
        "Test the _check_and_default_request_meta_data function, fail for no request date in header"
        logger.warning = mock.MagicMock()
        mock_datetime.now.return_value = datetime(year=2020, month=1, day=1, hour=00, minute=00, second=00)
        request = Request()
        del request.META["HTTP_X_REQUEST_RECEIVED"]
        view = CapacityStatusView()
        view._check_and_default_request_meta_data(request)
        calls = [
            mock.call("No request received date in header. Defaulting to now"),
        ]
        logger.warning.assert_has_calls(calls)
        error_msg = "Error should be for when the request doesn't have time"
        assert str(mock_datetime.now()) == str(request.META["HTTP_X_REQUEST_RECEIVED"]), error_msg

    def test__check_and_default_request_meta_data__fail__no_request_identifier(self):
        "Test the _check_and_default_request_meta_data function, fail for no request identifier in header"
        logger.warning = mock.MagicMock()
        request = Request()
        del request.META["HTTP_X_REQUEST_ID"]
        view = CapacityStatusView()
        view._check_and_default_request_meta_data(request)
        calls = [
            mock.call("No request identifier in header. Defaulting to xxx"),
        ]
        logger.warning.assert_has_calls(calls)
        error_msg = "Error should be for when the request doesn't have time"
        assert "xxx" == request.META["HTTP_X_REQUEST_ID"], error_msg

    def test__check_and_default_request_meta_data__fail__no_client_ip(self):
        "Test the _check_and_default_request_meta_data function, fail for no request client ip in header"
        logger.warning = mock.MagicMock()
        request = Request()
        del request.META["HTTP_X_CLIENT_IP"]
        view = CapacityStatusView()
        view._check_and_default_request_meta_data(request)
        calls = [
            mock.call("No client ip in header. Defaulting to 127.0.0.1"),
        ]
        logger.warning.assert_has_calls(calls)
        error_msg = "Error should be for when the request doesn't have an ip address"
        assert "127.0.0.1" == request.META["HTTP_X_CLIENT_IP"], error_msg
