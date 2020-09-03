from django.urls import path, include

from rest_framework import routers

from . import views

router = routers.DefaultRouter()

urlpatterns = [
    path(
        r"services/<int:id>/capacitystatus/",
        views.CapacityStatusView.as_view(),
    ),
    path("", include(router.urls)),
]
