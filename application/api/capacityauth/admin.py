# organizations/admin.py
import typing
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.db import models
from django.http.request import HttpRequest
from rest_framework_api_key.admin import APIKeyModelAdmin
# from .models import DosUserAPIKey, CapacityUser
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin, User
from .models import CapacityAuthDosUser


admin.site.site_header = "Capacity Status API Administration"


# @admin.register(DosUserAPIKey)
# class DosUserAPIKeyModelAdmin(APIKeyModelAdmin):

#     # form = DosUserAPIKeyAdminForm
#     is_change_view_call = False

#     def get_exclude(self, request, obj=None):
#         if self.exclude:
#             self.exclude += ["dos_user_id", "name"]
#         else:
#             self.exclude = ["dos_user_id", "name"]

#         return super().get_exclude(request, obj)

#     def get_readonly_fields(
#         self, request: HttpRequest, obj: models.Model = None
#     ) -> typing.Tuple[str, ...]:
#         fields = super().get_readonly_fields(request, obj)
#         if self.is_change_view_call:
#             fields += ("dos_username",)
#         return fields

#     def change_view(self, request, object_id, form_url="", extra_context=None):
#         self.is_change_view_call = True
#         return_value = super().change_view(request, object_id, form_url, extra_context)
#         self.is_change_view_call = False
#         return return_value

# class CapacityUserAdmin(UserAdmin):
#     model = CapacityUser

#     def get_fieldsets(self, request, obj=None):
#         fieldset = super().get_fieldsets(request, obj)
#         if "dos_username" not in  fieldset[0][1]["fields"]:
#             fieldset[0][1]["fields"] += ("dos_username",)
#         return fieldset

# admin.site.register(CapacityUser, CapacityUserAdmin)

class DosUserInline(admin.StackedInline):
    model = CapacityAuthDosUser
    can_delete = True
    verbose_name_plural = "DoS User"

    def get_exclude(self, request, obj=None):
        exclude = super().get_exclude(request, obj)
        if exclude is None:
            exclude = ["dos_user_id",]
        else:
            exclude += ["dos_user_id",]
        return exclude

class UserAdmin(BaseUserAdmin):
    inlines = (DosUserInline,)

admin.site.unregister(User)
admin.site.register(User, UserAdmin)



