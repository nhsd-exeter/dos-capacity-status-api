from django.core.management.base import BaseCommand, CommandError
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User
from ....authentication.models import CapacityAuthDosUser


class Command(BaseCommand):
    help = "Create a new user"

    def add_arguments(self, parser):
        parser.add_argument("username", type=str)
        parser.add_argument("password", type=str)

    def handle(self, *args, **options):
        username = options.get("username", None)
        password = options.get("password", None)
        try:
            user = (
                User.objects.db_manager("default")
                .filter(username__contains=username)
                .delete()
            )
        except ObjectDoesNotExist:
            pass
        finally:
            user = User.objects.db_manager("default").create_user(
                username=username, password=password
            )
            CapacityAuthDosUser.objects.db_manager("default").create(
                dos_username="TestUser", dos_user_id=1000000002, user=user
            )
            token = Token.objects.db_manager("default").create(user=user)
            print(token)
