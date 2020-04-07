from django.urls import include, path
from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from rest_framework import permissions

# from rest_framework.documentation import include_docs_urls

from .service.documentation import capacity_service_api_desc


"""
The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

schema_view = get_schema_view(
    openapi.Info(title="Capacity Status API", default_version="0.0.1", description=capacity_service_api_desc,),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

APP_PATH = "api/v0.0.1/capacity/"

urlpatterns = [
    path(APP_PATH, include("api.service.urls")),
    path(APP_PATH, include("api.authentication.urls")),
    path(APP_PATH + "apidoc/", include("rest_framework.urls", namespace="rest_framework"),),
    url(
        r"^" + APP_PATH + r"apidoc(?P<format>\.json|\.yaml)$",
        schema_view.without_ui(cache_timeout=0),
        name="schema-json",
    ),
    url(r"^" + APP_PATH + "apidoc/$", schema_view.with_ui("swagger", cache_timeout=0), name="schema-swagger-ui",),
    url(r"^" + APP_PATH + "altapidoc/$", schema_view.with_ui("redoc", cache_timeout=0), name="schema-redoc",),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
