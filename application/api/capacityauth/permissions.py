# organizations/permissions.py
from rest_framework_api_key.permissions import BaseHasAPIKey
from .models import DosUserAPIKey


class HasDosUserAPIKey(BaseHasAPIKey):
    model = DosUserAPIKey

    def get_key_model(self, request):

        key = super().get_key(request)
        prefix, _, _ = key.partition(".")

        return self.model.objects.get(prefix=prefix)
