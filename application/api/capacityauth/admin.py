# organizations/admin.py
import typing
from django.forms import ModelForm
from django.contrib import admin
from django.db import models
from django.http.request import HttpRequest
from rest_framework_api_key.admin import APIKeyModelAdmin
from .models import DosUserAPIKey

class DosUserAPIKeyAdminForm(ModelForm):
    def clean_dosusername(self):
        #TODO dos user validation
        return self.cleaned_data["dosusername"] + "-INTERCEPTED"

@admin.register(DosUserAPIKey)
class DosUserAPIKeyModelAdmin(APIKeyModelAdmin):

    form = DosUserAPIKeyAdminForm
    is_change_view_call = False

    def get_exclude(self, request, obj=None):
        if self.exclude == None:
            self.exclude = ["dosuserid", "name"]
        else :
            self.exclude = self.exclude + ["dosuserid", "name"]

        return super().get_exclude(request, obj)

    def get_readonly_fields(self, request: HttpRequest,
    obj: models.Model = None) -> typing.Tuple[str, ...]:
        fields = super().get_readonly_fields(request, obj)
        if self.is_change_view_call:
            fields += ("dosusername",)
        return fields

    def change_view(self, request, object_id, form_url='', extra_context=None):
        self.is_change_view_call = True
        return_value = super().change_view(request, object_id, form_url, extra_context)
        self.is_change_view_call = False
        return return_value


    def save_model(self, request, obj, form, change):
        obj.name = obj.dosusername
        obj.dosuserid = 2
        return super().save_model(request, obj, form, change)