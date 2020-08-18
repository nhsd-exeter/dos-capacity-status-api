from unittest import TestCase
from django.core.exceptions import ObjectDoesNotExist

# from datetime import datetime

from ..queries import can_user_edit_service, get_dos_service_for_uid, get_service_info, Users
from ..queries import get_dos_user_for_user_id, get_dos_user_for_username

from api.dos_interface.models import Services


class TestDosInterfaceQueries(TestCase):
    "Tests for dos query functions"

    def set_user_status(self, user_id=1000000001, status="ACTIVE"):
        user = Users.objects.db_manager("dos").get(id=user_id)
        user.status = status
        user.save()

    def set_service_status(self, service_uid="153455", status_id=1):
        service = Services.objects.db_manager("dos").get(uid=service_uid)
        service.statusid = status_id
        service.save()

    def test_can_user_edit_service__service_exists(self):
        "Test sql can_user_edit_service method, return true when the service is linked directly to the user"
        service_uid = "153455"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertTrue(user_can_edit)

    def test_can_user_edit_service__child_decendant_service_exists(self):
        "Test sql can_user_edit_service method,returns true when the service's parent is linked to the user"
        service_uid = "149198"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertTrue(user_can_edit)

    def test_can_user_edit_service__grandchild_decendant_service_exists(self):
        "Test sql can_user_edit_service method, returns true when the service's grand parent is linked to the user"
        service_uid = "162172"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertTrue(user_can_edit)

    def test_can_user_edit_service__is_not_linked_to_users(self):
        "Test sql can_user_edit_service method, returns false when the service does not exist"
        service_uid = "fake-uid"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_can_user_edit_service__does_not_exists(self):
        """Test sql can_user_edit_service method, returns false when the service isn't linked to the user directly
        or by ancestry"""
        service_uid = "133102"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_can_user_edit_service__does_not_have_the_right_permissions(self):
        "Test sql can_user_edit_service method, return false as the user does not have the correct permissions"
        service_uid = "153455"
        dos_user_id = 1000000000
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_can_user_edit_service__for_inactive_user(self):
        "Test sql can_user_edit_service method, return false when the user does not have an active status"
        self.set_user_status(user_id=1000000001, status="DUMMY_STATUS")
        service_uid = "153455"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_can_user_edit_service__for_inactive_service(self):
        """Test sql can_user_edit_service method, return false when given service (by uid) does not have an
        active status id (1)"""
        self.set_service_status(service_uid="153455", status_id=0)
        service_uid = "153455"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_can_user_edit_service__for_inactive_parent_service(self):
        """Test sql can_user_edit_service method, return false when the parent of the given service (by uid)
        does not have an active status id (1)"""
        self.set_service_status(service_uid="149198", status_id=0)
        service_uid = "149198"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    def test_get_dos_user_for_username(self):
        "Test get_dos_user_for_username method, return dos user model"
        username = "TestUser"
        return_value = get_dos_user_for_username(username)
        assert type(return_value) is Users
        assert return_value.username == username

    def test_get_dos_user_for_user_id(self):
        "Test get_dos_user_for_user_id method, return dos user model"
        user_id = 1000000001
        return_value = get_dos_user_for_user_id(user_id)
        assert type(return_value) is Users
        assert return_value.id == user_id

    def test_get_dos_service_for_uid__success(self):
        "Test get_dos_service_for_uid, success"
        service_uid = "149198"
        service = get_dos_service_for_uid(service_uid)
        self.assertIsInstance(service, Services)
        self.assertEqual(service.uid, service_uid)
        self.assertIsNotNone(service.name)
        self.assertNotEqual(service.name, "")

    def test_get_dos_service_for_uid__fail_raise(self):
        "Test get_dos_service_for_uid, fail raise (throwDoesNotExist=True)"
        service_uid = "000000"
        with self.assertRaises(ObjectDoesNotExist):
            get_dos_service_for_uid(service_uid)

    def test_get_dos_service_for_uid__fail_no_raise(self):
        "Test get_dos_service_for_uid , fail no raise (throwDoesNotExist=False)"
        service_uid = "000000"
        return_value = get_dos_service_for_uid(service_uid, throwDoesNotExist=False)
        self.assertIsNone(return_value)

    # def test_get_service_info__success(self):
    #     "Test get_service_info, success"
    #     service_uid = "149198"
    #     service_info = get_service_info(service_uid)
    #     self.assertEqual(len(service_info), 3)
    #     expected_keys = [
    #         "depth",
    #         "id",
    #         "uid",
    #         "name",
    #         "typeid",
    #         "notes",
    #         "modifiedby",
    #         "modifieddate",
    #         "resetdatetime",
    #         "color",
    #     ]
    #     for index in range(len(service_info)):
    #         service = service_info[index]
    #         self.assertListEqual(list(service.keys()), expected_keys)
    #         if index == 0:
    #             assert type(service["depth"]) is int and service["depth"] == 0
    #             assert service["uid"] == service_uid
    #             assert "Capacity" in service["notes"]
    #             assert type(service["modifiedby"]) is str and service["modifiedby"] is not None
    #             assert type(service["modifieddate"]) is datetime
    #             assert type(service["resetdatetime"]) is datetime
    #         else:
    #             assert type(service["depth"]) is int and service["depth"] == 1
    #             assert service["uid"] is not service_uid and service["uid"] is not None
    #             assert service["modifiedby"] is None
    #             assert service["modifieddate"] is None
    #             assert service["resetdatetime"] is None
    #         assert type(service["id"]) is int
    #         assert type(service["name"]) is str and service["name"] is not None
    #         assert type(service["typeid"]) is int
    #         assert service["color"] in ("RED", "AMBER", "GREEN")

    def test_get_service_info__fail(self):
        "Test get_service_info, fail"
        service_uid = "000000"
        with self.assertRaises(ObjectDoesNotExist):
            get_service_info(service_uid)

    # Re-activate users & services
    def tearDown(self):
        self.set_user_status(user_id=1000000001)
        self.set_service_status(service_uid="153455")
        self.set_service_status(service_uid="149198")
