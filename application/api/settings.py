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

# Note that the key is obtained from AWS Secrets in the production environment.
SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", "=tapo65h_g^cf4sxjawp-tl&z@1@5*&)p5gn2kax!^udtvs27c")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv("DJANGO_DEBUG", False)

ALLOWED_HOSTS = [
    ".amazonaws.com",
    "localhost",
]

SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
if os.getenv("HTTP_PROTOCOL", "https") == "http":
    SESSION_COOKIE_SECURE = False
    CSRF_COOKIE_SECURE = False
else:
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True

# Security Headers
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_HSTS_SECONDS = 30  # Set low for development (original 3600)

# Application definition
INSTALLED_APPS = [
    "rest_framework",
    "rest_framework.authtoken",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.messages",
    "django.contrib.sessions",
    "django.contrib.contenttypes",
    "django.contrib.staticfiles",
    "drf_yasg",
    "api.authentication",
    "api.dos_interface",
    "api.service",
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

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "HOST": os.getenv("API_DB_HOST", "db-dos"),
        "PORT": os.getenv("API_DB_PORT", "5432"),
        "NAME": os.getenv("API_DB_NAME", "capacity_status"),
        "USER": os.getenv("API_DB_USERNAME", "postgres"),
        "PASSWORD": os.getenv("API_DB_PASSWORD", "postgres"),
    },
    "dos": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "OPTIONS": {"options": "-c search_path=pathwaysdos"},
        "HOST": os.getenv("DOS_DB_HOST", "db-dos"),
        "PORT": os.getenv("DOS_DB_PORT", "5432"),
        "NAME": os.getenv("DOS_DB_NAME", "postgres"),
        "USER": os.getenv("DOS_DB_USERNAME", "capacity_status_api"),
        "PASSWORD": os.getenv("DOS_DB_PASSWORD", "capacity_status_api"),
    },
}

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    # Adds unique request id to logger.
    "filters": {"request_id": {"()": "request_id.logging.RequestIdFilter"}},
    "formatters": {
        "datetime_format": {"format": "%(asctime)s %(name)-25s %(levelname)-8s request_id=%(request_id)s %(message)s"},
        "usage_reporting_format": {"format": "%(message)s"},
    },
    "handlers": {
        "console": {
            "level": os.getenv("API_LOG_LEVEL", "INFO"),
            "class": "logging.StreamHandler",
            "formatter": "datetime_format",
            "filters": ["request_id"],
        },
        "usage_reporting": {"level": "INFO", "class": "logging.StreamHandler", "formatter": "usage_reporting_format"},
    },
    "loggers": {
        "django": {"handlers": ["console"], "level": os.getenv("API_LOG_LEVEL", "DEBUG")},
        "django.server": {
            # Nothing particularly interesting, so just return warning and above
            # to reduce log clutter.
            "handlers": ["console"],
            "level": "WARNING",
        },
        "api": {"handlers": ["console"], "level": os.getenv("API_LOG_LEVEL", "DEBUG")},
        "api.usage.reporting": {"handlers": ["usage_reporting"], "level": "INFO", "propagate": False},
    },
}

SWAGGER_SETTINGS = {
    "SECURITY_DEFINITIONS": {"Bearer": {"type": "token", "name": "Authorization", "in": "header"}},
    # May need this set to true when running over HTTPS.
    "USE_SESSION_AUTH": False,
}

# Password validation
# https://docs.djangoproject.com/en/3.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": ["rest_framework.authentication.TokenAuthentication"],
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.IsAuthenticated"],
}

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
REQUEST_ID_HEADER = os.getenv("REQUEST_ID_HEADER", None)

# Business Rules
RESET_STATUS_IN_DEFAULT_MINS = int(os.getenv("RESET_STATUS_IN_DEFAULT_MINS", 240))
RESET_STATUS_IN_MINIMUM_MINS = int(os.getenv("RESET_STATUS_IN_MINIMUM_MINS", 0))
RESET_STATUS_IN_MAX_MINS = int(os.getenv("RESET_STATUS_IN_MAX_MINS", 1440))
