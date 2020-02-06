import unittest

from ..queries import can_user_edit_service


class TestQueries(unittest.TestCase):
    "Tests for dos query functions"

    def test_can_user_edit_service__service_exists(self):
        "Test sql can_user_edit_service method, return true when the service is linked directly to the user"
        serviceUid = "153455"
        userId = 1000000001
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertTrue(user_can_edit)
        print(user_can_edit)

    def test_can_user_edit_service__child_decendant_service_exists(self):
        "Test sql can_user_edit_service method,returns true when the service's parent is linked to the user"
        serviceUid = "149198"
        userId = 1000000001
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertTrue(user_can_edit)
        print(user_can_edit)

    def test_can_user_edit_service__grandchild_decendant_service_exists(self):
        "Test sql can_user_edit_service method, returns true when the service's grand parent is linked to the user"
        serviceUid = "162172"
        userId = 1000000001
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertTrue(user_can_edit)
        print(user_can_edit)

    def test_can_user_edit_service__is_not_linked_to_users(self):
        "Test sql can_user_edit_service method, returns false when the service does not exist"
        serviceUid = "fake-uid"
        userId = 1000000001
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertFalse(user_can_edit)
        print(user_can_edit)

    def test_can_user_edit_service__does_not_exists(self):
        "Test sql can_user_edit_service method, returns false when the service isn't linked to the user directly or by ancestry"
        serviceUid = "133102"
        userId = 1000000001
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertFalse(user_can_edit)
        print(user_can_edit)

    def test_can_user_edit_service__does_not_have_the_right_permissions(self):
        "Test sql can_user_edit_service method, return false as the user does not have the correct permissions"
        serviceUid = "153455"
        userId = 1000000000
        user_can_edit = can_user_edit_service(userId, serviceUid)
        self.assertFalse(user_can_edit)
        print(user_can_edit)
