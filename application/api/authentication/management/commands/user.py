from ....authentication.models import CapacityAuthDosUser
from ....dos_interface.queries import get_dos_user_for_username
from django.contrib.auth.models import User
from django.core.exceptions import ObjectDoesNotExist
from django.core.management.base import BaseCommand, CommandError
from rest_framework.authtoken.models import Token


class Command(BaseCommand):
    help = "Create a new user"

    def add_arguments(self, parser):
        parser.add_argument("api_username", type=str)
        parser.add_argument("api_password", type=str)
        parser.add_argument("dos_username", type=str)

    def handle(self, *args, **options):
        api_username = options.get("api_username", None)
        api_password = options.get("api_password", None)
        dos_username = options.get("dos_username", None)
        try:
            api_user = (
                User.objects.db_manager("default")
                .filter(username__contains=api_username)
                .delete()
            )
        except ObjectDoesNotExist:
            pass
        finally:
            api_user = User.objects.db_manager("default").create_user(
                username=api_username, password=api_password
            )
            dos_user_id = get_dos_user_for_username(dos_username).id
            CapacityAuthDosUser.objects.db_manager("default").create(
                dos_username=dos_username, dos_user_id=dos_user_id, user=api_user
            )
            token = Token.objects.db_manager("default").create(user=api_user)
            print(token)
