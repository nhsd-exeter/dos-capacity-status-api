from django.db import migrations
from django.contrib.auth.models import Group, Permission
from django.core.management.sql import emit_post_migrate_signal


class Migration(migrations.Migration):

    dependencies = [
        ("capacityauth", "0002_create_admin_user"),
    ]

    def insertData(apps, schema_editor):
        group = Group(name="Key cobblers")
        group.save()

        # We need to call function below manually so that permissions
        # are correctly set up in the Django database before we attempt
        # to assign the permissions to the group. Note that this signal is
        # fired automatically by Django after each migration cycle, but it's
        # too late for us by then.
        emit_post_migrate_signal(2, False, "default")

        permissions = Permission.objects.filter(content_type_id=12)
        group.permissions.set(permissions)
        group.save()

    operations = [
        migrations.RunPython(insertData),
    ]
