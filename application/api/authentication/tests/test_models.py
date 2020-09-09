from unittest import TestCase, mock

from api.authentication import models
from api.authentication.models import CapacityAuthDosUser, validate_dos_username_exists
from api.dos_interface.models import Users as DosUser
from django.core.exceptions import (
    ValidationError,
    ObjectDoesNotExist,
    MultipleObjectsReturned,
)


class TestValidateDosUsernameExists(TestCase):
    #     "Test validate dos_username_exists_model function validator"

    @mock.patch.object(models, "get_dos_user_for_username")
    @mock.patch.object(models, "logger")
    def test_validate_dos_username_exists__no_validator_errors(self, mock_logger, mock_get_dos_user_for_username):
        "Test 'validate_dos_username_exists' method no validation errors"
        stub_dos_username = "stub_username"
        mock_get_dos_user_for_username.return_value = DosUser(id=101, username=stub_dos_username, status="ACTIVE")

        validate_dos_username_exists(stub_dos_username)

        mock_logger.info.assert_called_with("Validate DoS user exists for name: " + str(stub_dos_username))
        mock_logger.debug.assert_called_with(
            "DoS user exists with values: %s",
            mock_get_dos_user_for_username.return_value,
        )

    @mock.patch.object(models, "get_dos_user_for_username")
    @mock.patch.object(models, "logger")
    def test_validate_dos_username_exists__not_active_error(self, mock_logger, mock_get_dos_user_for_username):
        "Test 'validate_dos_username_exists' method not active user validation errors"
        stub_dos_username = "stub_username"
        mock_get_dos_user_for_username.return_value = DosUser(id=101, username=stub_dos_username, status="PENDING")
        with self.assertRaises(ValidationError):
            try:
                validate_dos_username_exists(stub_dos_username)

            except ValidationError as e:
                self.assertEqual(
                    ["Username '" + stub_dos_username + "' is not an 'ACTIVE' DoS user"],
                    e.messages,
                )
                raise e

        mock_logger.info.assert_called_with("Validate DoS user exists for name: " + str(stub_dos_username))
        mock_logger.debug.assert_called_with(
            "DoS user exists with values: %s",
            mock_get_dos_user_for_username.return_value,
        )

    @mock.patch.object(models, "get_dos_user_for_username")
    @mock.patch.object(models, "logger")
    def test_validate_dos_username_exists__username_does_not_exist_error(
        self, mock_logger, mock_get_dos_user_for_username
    ):
        "Test 'validate_dos_username_exists' method, username does not exist validation error"
        stub_dos_username = "stub_username"
        mock_get_dos_user_for_username.side_effect = ObjectDoesNotExist()
        with self.assertRaises(ValidationError):
            try:
                validate_dos_username_exists(stub_dos_username)

            except ValidationError as e:
                self.assertEqual(
                    ["Username '" + stub_dos_username + "' does not exist in DoS"],
                    e.messages,
                )
                raise e

        mock_logger.info.assert_called_with("Validate DoS user exists for name: " + str(stub_dos_username))

    @mock.patch.object(models, "get_dos_user_for_username")
    @mock.patch.object(models, "logger")
    def test_validate_dos_username_exists__multiple_users_with_username_error(
        self, mock_logger, mock_get_dos_user_for_username
    ):
        "Test 'validate_dos_username_exists' method, multiple users with user validation error"
        stub_dos_username = "stub_username"
        mock_get_dos_user_for_username.side_effect = MultipleObjectsReturned()
        with self.assertRaises(ValidationError):
            try:
                validate_dos_username_exists(stub_dos_username)

            except ValidationError as e:
                self.assertEqual(
                    ["Unexpected multiple DoS users with given username '" + stub_dos_username + "'"],
                    e.messages,
                )
                raise e

        mock_logger.info.assert_called_with("Validate DoS user exists for name: " + str(stub_dos_username))


class TestCapacityAuthDosUser(TestCase):
    #     "Test CapacityAuthDosUser model class method"

    @mock.patch("api.authentication.models.super")
    @mock.patch.object(models, "get_dos_user_for_username")
    def test_save(self, mock_get_dos_user_for_username, mock_super):
        capacity_auth_dos_user = CapacityAuthDosUser(dos_username="stub_username")
        dos_user = DosUser(id=32)
        mock_get_dos_user_for_username.return_value = dos_user
        mock_super().save.return_value = "stub_return"

        return_value = capacity_auth_dos_user.save()
        mock_get_dos_user_for_username.assert_called_with(capacity_auth_dos_user.dos_username)
        mock_super().save.assert_called()
        self.assertEqual(mock_super().save.return_value, return_value)
