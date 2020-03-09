from unittest import TestCase, mock

from ..authorise import User, Services, ApiDosUserAssociations
from ..authorise import convert_api_user_to_dos_user_id
from ..authorise import can_api_user_edit_service
from .. import authorise


class TestConvertApiUserToDosUserId(TestCase):
    "Test authorising api user against dos"

    @mock.patch.object(ApiDosUserAssociations.objects, "filter")
    def test_convert_api_user_to_dos_user_id__success(self, mock_filter):
        "Test convert api user to dos user id method, success"
        api_user = User(id=1)
        dos_user_id = 1000000001
        mock_filter.return_value = (ApiDosUserAssociations(dosuserid=dos_user_id),)

        returned_dos_user_id = convert_api_user_to_dos_user_id(api_user)

        self.assertEqual(returned_dos_user_id, dos_user_id)
        mock_filter.assert_called_with(apiuserid=api_user.id)

    @mock.patch.object(ApiDosUserAssociations.objects, "filter")
    def test_convert_api_user_to_dos_user_id__fail_api_user_does_not_exist(self, mock_filter):
        "Test convert api user to dos user id method, fail api user does not exist"
        api_user = User(id=99)
        expected_dos_user_id = None
        mock_filter.return_value = ()

        dos_user_id = convert_api_user_to_dos_user_id(api_user)

        self.assertEqual(dos_user_id, expected_dos_user_id)
        mock_filter.assert_called_with(apiuserid=api_user.id)

    def test_convert_api_user_to_dos_user_id__fail_api_user_is_none(self):
        """Test convert api user to dos user id method,
        fail give api user is of none value"""
        api_user = None
        try:
            convert_api_user_to_dos_user_id(api_user)
            self.fail("An AttributeError should have been throw for given 'None' api user")
        except AttributeError:
            "Success"


class TestCanApiUserEdit_service(TestCase):
    "Test can api user edit a dos service"

    @mock.patch.object(authorise, "convert_api_user_to_dos_user_id")
    @mock.patch.object(authorise, "can_user_edit_service")
    def test_can_api_user_edit_service__success(
        self, mock_can_user_edit_service, mock_convert_api_user_to_dos_user_id
    ):
        "Test can api user edit service, success"
        api_user = User(id=22)
        dos_user_id = 88
        service = Services(uid="STUB00")
        mock_convert_api_user_to_dos_user_id.return_value = dos_user_id
        mock_can_user_edit_service.return_value = True

        result = can_api_user_edit_service(api_user, service)

        self.assertTrue(result)
        mock_convert_api_user_to_dos_user_id.assert_called_with(api_user)
        mock_can_user_edit_service.assert_called_with(dos_user_id, service.uid)

    @mock.patch.object(authorise, "convert_api_user_to_dos_user_id")
    @mock.patch.object(authorise, "can_user_edit_service")
    def test_can_api_user_edit_service__fail_dos_lookup(
        self, mock_can_user_edit_service, mock_convert_api_user_to_dos_user_id
    ):
        "Test can api user edit service, fail dos lookup"
        api_user = User(id=22)
        dos_user_id = 88
        service = Services(uid="STUB00")
        mock_convert_api_user_to_dos_user_id.return_value = dos_user_id
        mock_can_user_edit_service.return_value = False

        result = can_api_user_edit_service(api_user, service)

        self.assertFalse(result)
        mock_convert_api_user_to_dos_user_id.assert_called_with(api_user)
        mock_can_user_edit_service.assert_called_with(dos_user_id, service.uid)

    def test_can_api_user_edit_service__fail_service_is_none(self):
        "Test can api user edit service, fail given service is of none value"
        api_user = User(id=1)
        service = None
        # TODO: FIX THIS - see how to test for exceptions here:
        # https://docs.python.org/3/library/unittest.html#unittest.TestCase.assertRaises
        try:
            can_api_user_edit_service(api_user, service)
            self.fail("An AttributeError should have been throw for given 'None' service")
        except:
            "Success"
