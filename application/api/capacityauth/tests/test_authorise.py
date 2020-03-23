from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Manager
from django.contrib.auth.models import User
from unittest import TestCase, mock
from ..models import CapacityAuthDosUser
from ..authorise import get_dos_user, can_capacity_user_edit_service
from .. import authorise
from api.dos.models import Users as DosUser
from api.dos import queries

class TestGetDosUser(TestCase):
#     "Test retrieval of Dos User API Key from the DoS (Django) app"

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
    def test_get_dos_user__fail_dos_lookup(self, mock_db_manager, mock_get_user_for_id):
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

    @mock.patch.object(queries, "can_user_edit_service")
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







# class TestGetUserForkey(TestCase):
#     "Test retrieval of Dos User API Key from the DoS (Django) app"

#     @mock.patch.object(authorise, "get_dos_user_for_user_id")
#     def test_get_dos_user_for_user_id__success(self, mock_method):
#         "Test 'get_dos_user' method, success" 1§
#         capacity_user = CapacityAuthDosUser(dos_user_id=101)
#         mock_method.return_value = Users(id=capacity_user.dos_user_id)

#         return_value = get_dos_user(capacity_user)

#         self.assertTrue(return_value)
#         mock_method.assert_called_with(capacity_user.dos_user_id)

#     @mock.patch.object(authorise, "get_dos_user_for_user_id")
#     def test_get_dos_user_for_user_id__fail(self, mock_method):
#         "Test 'get_dos_user' method, fail"
#         capacity_user = CapacityAuthDosUser(dos_user_id=101)
#         mock_method.side_effect = ObjectDoesNotExist("User does not exist")
#         return_value = get_dos_user(capacity_user)

#         self.assertIsNone(return_value)
#         mock_method.assert_called_with(capacity_user.dos_user_id)

# from unittest import TestCase, mock
# from django.db.models.query import QuerySet

# from ..authorise import User, Services, ApiDosUserAssociations
# from ..authorise import convert_api_user_to_dos_user_id
# from ..authorise import can_api_user_edit_service
# from .. import authorise


# class TestConvertApiUserToDosUserId(TestCase):
#     "Test authorising api user against dos"

#     @mock.patch.object(ApiDosUserAssociations.objects, "filter")
#     def test_convert_api_user_to_dos_user_id__success(self, mock_filter):
#         "Test convert api user to dos user id method, success"
#         api_user = User(id=1)
#         dos_user_id = 1000000001
#         mock_filter.return_value = (ApiDosUserAssociations(dosuserid=dos_user_id),)

#         returned_dos_user_id = convert_api_user_to_dos_user_id(api_user)

#         self.assertEqual(returned_dos_user_id, dos_user_id)
#         mock_filter.assert_called_with(apiuserid=api_user.id)

#     @mock.patch.object(ApiDosUserAssociations.objects, "filter")
#     def test_convert_api_user_to_dos_user_id__fail_api_user_does_not_exist(
#         self, mock_filter
#     ):
#         "Test convert api user to dos user id method, fail api user does not exist"
#         api_user = User(id=99)
#         expected_dos_user_id = None
#         mock_filter.return_value = ()

#         dos_user_id = convert_api_user_to_dos_user_id(api_user)

#         self.assertEqual(dos_user_id, expected_dos_user_id)
#         mock_filter.assert_called_with(apiuserid=api_user.id)

#     def test_convert_api_user_to_dos_user_id__fail_api_user_is_none(self):
#         """Test convert api user to dos user id method,
#         fail give api user is of none value"""
#         api_user = None
#         try:
#             dos_user_id = convert_api_user_to_dos_user_id(api_user)
#             self.fail(
#                 "An AttributeError should have been throw for given 'None' api user"
#             )
#         except AttributeError:
#             "Success"


# class TestCanApiUserEdit_service(TestCase):
#     "Test can api user edit a dos service"

#     @mock.patch.object(authorise, "convert_api_user_to_dos_user_id")
#     @mock.patch.object(authorise, "can_user_edit_service")
#     def test_can_api_user_edit_service__success(
#         self, mock_can_user_edit_service, mock_convert_api_user_to_dos_user_id
#     ):
#         "Test can api user edit service, success"
#         api_user = User(id=22)
#         dos_user_id = 88
#         service = Services(uid="STUB00")
#         mock_convert_api_user_to_dos_user_id.return_value = dos_user_id
#         mock_can_user_edit_service.return_value = True

#         result = can_api_user_edit_service(api_user, service)

#         self.assertTrue(result)
#         mock_convert_api_user_to_dos_user_id.assert_called_with(api_user)
#         mock_can_user_edit_service.assert_called_with(dos_user_id, service.uid)

#     @mock.patch.object(authorise, "convert_api_user_to_dos_user_id")
#     @mock.patch.object(authorise, "can_user_edit_service")
#     def test_can_api_user_edit_service__fail_dos_lookup(
#         self, mock_can_user_edit_service, mock_convert_api_user_to_dos_user_id
#     ):
#         "Test can api user edit service, fail dos lookup"
#         api_user = User(id=22)
#         dos_user_id = 88
#         service = Services(uid="STUB00")
#         mock_convert_api_user_to_dos_user_id.return_value = dos_user_id
#         mock_can_user_edit_service.return_value = False

#         result = can_api_user_edit_service(api_user, service)

#         self.assertFalse(result)
#         mock_convert_api_user_to_dos_user_id.assert_called_with(api_user)
#         mock_can_user_edit_service.assert_called_with(dos_user_id, service.uid)

#     def test_can_api_user_edit_service__fail_service_is_none(self):
#         "Test can api user edit service, fail given service is of none value"
#         api_user = User(id=1)
#         service = None
#         try:
#             result = can_api_user_edit_service(api_user, service)
#             self.fail(
#                 "An AttributeError should have been throw for given 'None' service"
#             )
#         except:
#             "Success"

        mock_get_dos_user.assert_called_with(capacity_user)
        mock_can_user_edit_service.assert_not_called()
        self.assertFalse(return_value)
