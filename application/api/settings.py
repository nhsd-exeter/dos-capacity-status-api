"""
Django settings for api project.

Generated by 'django-admin startproject' using Django 3.0.

For more information on this file, see
https://docs.djangoproject.com/en/3.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.0/ref/settings/
"""

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "=tapo65h_g^cf4sxjawp-tl&z@1@5*&)p5gn2kax!^udtvs27c"

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
    "ace16b804651711ea982e0277ad65c07-1090173710.eu-west-2.elb.amazonaws.com"
]

# TODO [Needs Reviewing Start] Added as part of enabling https with gunicorn need to review if the following is needed
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
# if os.getenv("PROFILE", "prod") == "local":
#    SESSION_COOKIE_SECURE = False
#    CSRF_COOKIE_SECURE = False
# else:
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

# Security Headers
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_HSTS_SECONDS = 30  # Set low for development (original 3600)
# TODO [Needs Reviewing End]

# Application definition

INSTALLED_APPS = [
    "rest_framework",
    "rest_framework_api_key",
    "django.contrib.admin",
    "django.contrib.auth",
    # messages and sessions APP is needed for the auth APP
    "django.contrib.messages",
    "django.contrib.sessions",
    "django.contrib.contenttypes",
    "django.contrib.staticfiles",
    "api.dos",
    "api.capacityservice",
    "api.capacityauth",
    "drf_yasg",
]

MIDDLEWARE = [
    # Adds unique request id to logs https://django-request-id.readthedocs.io/en/latest/
    "request_id.middleware.RequestIdMiddleware",
    "request_logging.middleware.LoggingMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "api.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "api.wsgi.application"

# Database
# https://docs.djangoproject.com/en/3.0/ref/settings/#databases

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "HOST": "uec-dos-api-cs-nonprod-db.cqger35bxcwy.eu-west-2.rds.amazonaws.com",
        "PORT": "5432",
        "NAME": "cap_status_api",
        "USER": "postgres",
        "PASSWORD": "password",
    },
    "dos": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "OPTIONS": {"options": "-c search_path=pathwaysdos"},
        "HOST": "uec-dos-api-cs-nonprod-db.cqger35bxcwy.eu-west-2.rds.amazonaws.com",
        "PORT": "5432",
        "NAME": "postgres",
        "USER": "postgres",
        "PASSWORD": "password",
    },
}

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    # Adds unique request id to logger.
    "filters": {"request_id": {"()": "request_id.logging.RequestIdFilter"}},
    "formatters": {
        "datetime_format": {
            "format": "%(asctime)s %(name)-25s %(levelname)-8s request_id=%(request_id)s %(message)s",
        },
    },
    "handlers": {
        "console": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
            "formatter": "datetime_format",
            "filters": ["request_id"],
        },
        "file": {
            "level": "DEBUG",
            "class": "logging.handlers.RotatingFileHandler",
            "filename": os.path.join(BASE_DIR, "logs/capacity-status-api-debug.log"),
            "maxBytes": 1024 * 1024 * 15,  # 15MB
            "backupCount": 10,
            "formatter": "datetime_format",
            "filters": ["request_id"],
        },
    },
    "loggers": {
        "django": {
            "handlers": ["console", "file"],
            "level": os.getenv("DJANGO_LOG_LEVEL", "DEBUG"),
        },
        "django.server": {
            # Nothing particularly interesting, so just return warning and above
            # to reduce log clutter.
            "handlers": ["console", "file"],
            "level": "WARNING",
        },
        "api": {
            "handlers": ["console", "file"],
            "level": os.getenv("DJANGO_LOG_LEVEL", "DEBUG"),
        },
    },
}

SWAGGER_SETTINGS = {
    "SECURITY_DEFINITIONS": {
        "Bearer": {"type": "apiKey", "name": "Authorization", "in": "header"},
    },
    # May need this set to true when running over HTTPS.
    "USE_SESSION_AUTH": False,
}

# Password validation
# https://docs.djangoproject.com/en/3.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",},
]


# Internationalization
# https://docs.djangoproject.com/en/3.0/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.0/howto/static-files/

STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "static/")

# Generates a unique request identifier for ever request processed and outputs this in the logs.
# This is so we can trace a request all the way through.
# https://django-request-id.readthedocs.io/en/latest/
REQUEST_ID_HEADER = None
