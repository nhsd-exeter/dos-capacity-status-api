from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin, User
from .models import CapacityAuthDosUser

admin.site.site_header = "Capacity Status API Administration"


class DosUserInline(admin.StackedInline):
    model = CapacityAuthDosUser
    can_delete = True
    verbose_name_plural = "DoS User"

    def get_exclude(self, request, obj=None):
        exclude = super().get_exclude(request, obj)
        if exclude is None:
            exclude = [
                "dos_user_id",
            ]
        else:
            exclude += [
                "dos_user_id",
            ]
        return exclude


class UserAdmin(BaseUserAdmin):
    inlines = (DosUserInline,)


admin.site.unregister(User)
admin.site.register(User, UserAdmin)
