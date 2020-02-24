from unittest import TestCase

from ..queries import can_user_edit_service, Users
from ..models import Services


class TestCanUserEditService(TestCase):
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
        "Test sql can_user_edit_service method, returns false when the service isn't linked to the user directly or by ancestry"
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
        "Test sql can_user_edit_service method, return false when given service (by uid) does not have an active status id (1)"
        self.set_service_status(service_uid="153455", status_id=0)
        service_uid = "153455"
        dos_user_id = 1000000001
        user_can_edit = can_user_edit_service(dos_user_id, service_uid)
        self.assertFalse(user_can_edit)

    # Re-activate users & services
    def tearDown(self):
        self.set_user_status(user_id=1000000001)
        self.set_service_status(service_uid="153455")

