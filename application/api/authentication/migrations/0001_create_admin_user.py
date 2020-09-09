import os
from django.db import migrations


class Migration(migrations.Migration):
    def generate_superuser(apps, schema_editor):
        from django.contrib.auth.models import User

        DJANGO_SU_NAME = "admin"
        DJANGO_SU_PASSWORD = os.environ.get("API_ADMIN_PASSWORD")

        if (DJANGO_SU_PASSWORD) is None:
            raise Exception("Admin password in API_ADMIN_PASSWORD environment variable has not been specified")

        superuser = User.objects.create_superuser(
            username=DJANGO_SU_NAME,
            password=DJANGO_SU_PASSWORD,
        )

        superuser.save()

    operations = [
        migrations.RunPython(generate_superuser),
    ]
