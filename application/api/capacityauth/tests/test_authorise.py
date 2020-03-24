from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.models import User
from unittest import TestCase, mock

from ..models import CapacityAuthDosUser
from ..authorise import get_dos_user, can_capacity_user_edit_service
from api.dos.models import Users as DosUser
from api.dos import queries
from .. import authorise

class TestGetDosUser(TestCase):
#     "Test retrieval of Dos User from DoS (Django) app for a Capacity User"

    @mock.patch.object(authorise, "get_dos_user_for_user_id")
    @mock.patch.object(CapacityAuthDosUser.objects, "db_manager")
    def test_get_dos_user__success(self, mock_db_manager, mock_get_user_for_id):
        "Test 'get_dos_user' method, success"
        capacity_user = User(id=3)
        dos_capacity_user = CapacityAuthDosUser(user_id=capacity_user.id, dos_user_id=101)
        dos_user = DosUser(id=dos_capacity_user.dos_user_id)
        mock_queryset = mock.Mock()
        mock_queryset.configure_mock(**{'get.return_value': dos_capacity_user})
        mock_db_manager.return_value = mock_queryset
        mock_get_user_for_id.return_value = dos_user

        return_value = get_dos_user(capacity_user)

        self.assertEqual(dos_user, return_value)
        mock_db_manager.assert_called_with("default")
        mock_queryset.get.assert_called_with(user_id=capacity_user.id)
        mock_get_user_for_id.assert_called_with(dos_capacity_user.dos_user_id)

    @mock.patch.object(authorise, "get_dos_user_for_user_id")
    @mock.patch.object(CapacityAuthDosUser.objects, "db_manager")
    def test_get_dos_user__fail(self, mock_db_manager, mock_get_user_for_id):
        "Test 'get_dos_user' method, fail dos lookup"
        capacity_user = User(id=3)
        dos_capacity_user = CapacityAuthDosUser(user_id=capacity_user.id, dos_user_id=101)
        dos_user = DosUser(id=dos_capacity_user.dos_user_id)
        mock_queryset = mock.Mock()
        mock_queryset.configure_mock(**{'get.return_value': dos_capacity_user})
        mock_db_manager.return_value = mock_queryset
        mock_get_user_for_id.side_effect = ObjectDoesNotExist("User does not exist")

        return_value = get_dos_user(capacity_user)

        self.assertIsNone(return_value)
        mock_db_manager.assert_called_with("default")
        mock_queryset.get.assert_called_with(user_id=capacity_user.id)
        mock_get_user_for_id.assert_called_with(dos_capacity_user.dos_user_id)

    @mock.patch.object(authorise, "can_user_edit_service")
    @mock.patch.object(authorise, "get_dos_user")
    def test_can_capacity_user_edit_service__success(self, mock_get_dos_user, mock_can_user_edit_service):
        "Test 'can_capacity_user_edit_service' method, success"
        capacity_user = User(id=3)
        dos_user = DosUser(id=101)
        service_uid = "stub_id"
        mock_get_dos_user.return_value = dos_user
        mock_can_user_edit_service.return_value = True

        return_value = can_capacity_user_edit_service(capacity_user, service_uid)

        mock_get_dos_user.assert_called_with(capacity_user)
        mock_can_user_edit_service.assert_called_with(dos_user.id, service_uid)
        self.assertTrue(return_value)


    @mock.patch.object(authorise, "can_user_edit_service")
    @mock.patch.object(authorise, "get_dos_user")
    def test_can_capacity_user_edit_service__fail(self, mock_get_dos_user, mock_can_user_edit_service):
        "Test 'can_capacity_user_edit_service' method, fail_get_dos_user"
        capacity_user = User(id=3)
        service_uid = "stub_id"
        mock_get_dos_user.return_value = None
        mock_can_user_edit_service.return_value = False

        return_value = can_capacity_user_edit_service(capacity_user, service_uid)

        mock_get_dos_user.assert_called_with(capacity_user)
        mock_can_user_edit_service.assert_not_called()
        self.assertFalse(return_value)
