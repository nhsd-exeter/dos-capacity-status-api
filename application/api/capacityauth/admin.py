# organizations/admin.py
import typing
from django.contrib import admin
from django.db import models
from django.http.request import HttpRequest
from rest_framework_api_key.admin import APIKeyModelAdmin
from .models import DosUserAPIKey

admin.site.site_header = "Capacity Status API Administration"


@admin.register(DosUserAPIKey)
class DosUserAPIKeyModelAdmin(APIKeyModelAdmin):

    # form = DosUserAPIKeyAdminForm
    is_change_view_call = False

    def get_exclude(self, request, obj=None):
        if self.exclude:
            self.exclude += ["dos_user_id", "name"]
        else:
            self.exclude = ["dos_user_id", "name"]

        return super().get_exclude(request, obj)

    def get_readonly_fields(
        self, request: HttpRequest, obj: models.Model = None
    ) -> typing.Tuple[str, ...]:
        fields = super().get_readonly_fields(request, obj)
        if self.is_change_view_call:
            fields += ("dos_username",)
        return fields

    def change_view(self, request, object_id, form_url="", extra_context=None):
        self.is_change_view_call = True
        return_value = super().change_view(request, object_id, form_url, extra_context)
        self.is_change_view_call = False
        return return_value
