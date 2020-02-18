# organizations/permissions.py
from rest_framework_api_key.permissions import BaseHasAPIKey
from .models import DosUserAPIKey


class HasDosUserAPIKey(BaseHasAPIKey):
    model = DosUserAPIKey
