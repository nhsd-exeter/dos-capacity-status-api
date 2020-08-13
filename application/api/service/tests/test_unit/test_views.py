from unittest import TestCase, mock
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist

from django.contrib.auth.models import User as AuthUser
from rest_framework import status
from rest_framework.response import Response
from ...views import CapacityStatusView, logger
from ....authentication.models import CapacityAuthDosUser
from ....dos_interface.models import Users as DosUser, ServiceCapacities, Services, Capacitystatuses
from ...serializers.model_serializers import CapacityStatusModelSerializer


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

    auth_user = None
    capacity_auth_user_link = None

    def add_auth_user_to_database(self):
        if self.auth_user is None:
            self.auth_user = AuthUser.objects.db_manager("default").create(
                password="stub_password",
                is_superuser=False,
                username="UnitTestUser",
                first_name="Unit Test",
                last_name="User",
                email="unittestuser@test",
                is_staff=False,
                is_active=True,
            )
        return self.auth_user

    def link_dos_user_to_capacity_auth_user(self, dos_user_id, dos_username):
        if self.auth_user is None:
            raise Exception("No auth user has been created for test")
        if self.capacity_auth_user_link is None:
            self.capacity_auth_user_link = CapacityAuthDosUser.objects.db_manager("default").create(
                dos_user_id=dos_user_id, dos_username=dos_username, user_id=self.auth_user.id
            )
        else:
            self.capacity_auth_user_link.dos_user_id = dos_user_id
            self.capacity_auth_user_link.dos_username = dos_username
            self.capacity_auth_user_link.save()
        return self.capacity_auth_user_link

    def tearDown(self):
        if self.auth_user is not None:
            self.auth_user.delete()

        return super().tearDown()

    def test_get__fail__no_user(self):
        "Test the get endpoint function, fail for nonexistent user"
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

    def test_put__success(self):
        "Test the put endpoint function"
        logger.info = mock.MagicMock()
        request = PutRequest()
        service_id = 149198
        request.data = {"status": "AMBER"}
        request.user = self.add_auth_user_to_database()
        self.link_dos_user_to_capacity_auth_user("1000000002", "EditUser")
        view = CapacityStatusView()
        view.kwargs = {view.lookup_url_kwarg: service_id}
        view.request = request
        view.format_kwarg = None
        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        assert response.status_code is status.HTTP_200_OK
        expected_keys = [
            "id",
            "name",
            "status",
            "resetDateTime",
            "notes",
            "modifiedBy",
            "modifiedDate",
        ]
        assert list(response.data.keys()) == expected_keys
        assert response.data["id"] == service_id
        for key in expected_keys:
            if key != "id":
                assert type(response.data[key]) is str and response.data[key] != ""
        assert response.data["status"] == "AMBER"
        assert response.data["modifiedBy"] == "EditUser"
        datetime_format = "%Y-%m-%dT%H:%M:%SZ"
        reset_datetime = datetime.strptime(response.data["resetDateTime"], datetime_format)
        modified_datetime = datetime.strptime(response.data["modifiedDate"], datetime_format)
        delta_to_reset = reset_datetime - modified_datetime
        assert (delta_to_reset.seconds / 3600) == 4

    def test_put__fail_invalid_color(self):
        "Test the put endpoint function, fails for invalid color"
        logger.info = mock.MagicMock()
        request = PutRequest()
        service_id = 149198
        request.data = {"status": "BLUE"}
        request.user = self.add_auth_user_to_database()
        self.link_dos_user_to_capacity_auth_user("1000000002", "EditUser")
        view = CapacityStatusView()
        view.kwargs = {view.lookup_url_kwarg: service_id}
        view.request = request
        view.format_kwarg = None
        response = view.put(request, service_id)
        calls = [
            mock.call("Request sent from host: %s", request.META["HTTP_HOST"]),
            mock.call("Payload: %s", request.data),
        ]
        logger.info.assert_has_calls(calls)
        assert type(response) is Response
        error_msg = "Should report a bad request for an invalid color"
        assert response.status_code is status.HTTP_400_BAD_REQUEST, error_msg
        assert "Capacity Status value is invalid" in response.data["status"][0]
        assert response.data["status"][0].code == "invalid_choice"

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

    def test__get_service_capacity__success(self):
        "Test the _get_service_capacity function"
        view = CapacityStatusView()
        response = view._get_service_capacity(service_uid="149198")
        assert type(response) is ServiceCapacities
        assert type(response.service) is Services
        assert type(response.status) is Capacitystatuses
        assert response.service.uid == "149198"
        assert response.status.color in ["RED", "AMBER", "GREEN"]

    def test__serialized_get_capacity_response(self):
        "Test the _serialized_get_capacity function"
        view = CapacityStatusView()
        service = Services(uid="100", name="dummy_service")

        capacity_status = Capacitystatuses(capacitystatusid=1, color="RED")
        service_capacities = ServiceCapacities(
            status=capacity_status,
            service=service,
            notes="Test notes",
            resetdatetime=datetime.now(),
            modifiedbyid=20,
            modifiedby="dummy_test_user",
            modifieddate=datetime.now(),
        )
        response = view._serialized_get_capacity_response(service_capacities)
        assert response.status_code is status.HTTP_200_OK
        datetime_format = "%Y-%m-%dT%H:%M:%S.%fZ"
        expected_data = {
            "id": int(service.uid),
            "name": service.name,
            "status": capacity_status.color,
            "resetDateTime": datetime.strftime(service_capacities.resetdatetime, datetime_format),
            "notes": service_capacities.notes,
            "modifiedBy": service_capacities.modifiedby,
            "modifiedDate": datetime.strftime(service_capacities.modifieddate, datetime_format),
        }
        assert response.data == expected_data

    def test__serialized_get_capacity_response__bad_request(self):
        "Test the _serialized_get_capacity function, bad request"
        view = CapacityStatusView()
        service = Services(uid="100", name="dummy_service")

        capacity_status = Capacitystatuses(capacitystatusid=1, color=None)
        service_capacities = ServiceCapacities(
            status=capacity_status,
            service=service,
            notes="Test notes",
            resetdatetime=datetime.now(),
            modifiedbyid=20,
            modifiedby="dummy_test_user",
            modifieddate=datetime.now(),
        )
        response = view._serialized_get_capacity_response(service_capacities)
        assert response.status_code is status.HTTP_400_BAD_REQUEST

    @mock.patch("api.service.views.get_dos_user")
    def test__update_service_capacity(self, mock_get_dos_user):
        "Test the _update_service_capacity function, success"
        request = PutRequest()
        request.data = {"status": "RED"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        mock_get_dos_user.return_value = DosUser(id=1010, username="dummy_dos_user")
        view = CapacityStatusView()
        view.partial_update = mock.MagicMock()
        response = view._update_service_capacity(request, service_id)
        assert response is None

    @mock.patch("api.service.views.get_dos_user")
    def test__update_service_capacity__fail_invalid_color(self, mock_get_dos_user):
        "Test the _update_service_capacity function, failed invalid color"
        request = PutRequest()
        request.data = {"status": "BLUE"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        mock_get_dos_user.return_value = DosUser(id=1010, username="dummy_dos_user")
        view = CapacityStatusView()
        view.partial_update = mock.MagicMock()
        response = view._update_service_capacity(request, service_id)
        assert type(response) is Response
        assert response.status_code is status.HTTP_400_BAD_REQUEST

    @mock.patch.object(CapacityStatusModelSerializer, "errors")
    @mock.patch.object(CapacityStatusModelSerializer, "is_valid")
    @mock.patch("api.service.views.get_dos_user")
    def test__update_service_capacity__fail_invalid_model(self, mock_get_dos_user, mock_is_valid, mock_errors):
        "Test the _update_service_capacity function, failed invalid capacity status model"
        request = PutRequest()
        request.data = {"status": "RED"}
        request.user = CapacityAuthDosUser()
        request.user.dos_user_id = 1010
        request.user.dos_username = "dummy_dos_user"
        service_id = 101010
        mock_get_dos_user.return_value = DosUser(id=1010, username="dummy_dos_user")
        mock_is_valid.return_value = False
        mock_errors.return_value = {}
        view = CapacityStatusView()
        view.partial_update = mock.MagicMock()
        response = view._update_service_capacity(request, service_id)
        assert type(response) is Response

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
