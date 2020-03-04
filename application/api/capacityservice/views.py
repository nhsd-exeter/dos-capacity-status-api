from django.http import HttpResponse
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.response import Response

from drf_yasg.utils import swagger_auto_schema

from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework_api_key.permissions import HasAPIKey

from .serializers.model_serializers import CapacityStatusModelSerializer
from .serializers.payload_serializer import CapacityStatusRequestPayloadSerializer

from .serializers.response_serializer import CapacityStatusResponseSerializer

from .models import ServiceCapacities
from api.capacityauth.permissions import HasDosUserAPIKey

from api.capacityauth.authorise import (
    can_dos_user_api_key_edit_service,
    get_user_for_key,
)
from api.dos.queries import get_dos_service_for_uid
from .documentation import (
    description_get,
    description_post,
    service_uid_path_param,
    validation_error_response,
    authentication_error_response,
)

import logging

logger = logging.getLogger(__name__)


class CapacityStatusView(RetrieveUpdateAPIView):
    permission_classes = [HasDosUserAPIKey]
    queryset = ServiceCapacities.objects.db_manager("dos").all()
    serializer_class = CapacityStatusModelSerializer
    lookup_field = "service__uid"

    @swagger_auto_schema(
        operation_description=description_get,
        manual_parameters=[service_uid_path_param],
        responses={
            200: CapacityStatusResponseSerializer,
            401: authentication_error_response,
            404: "Not Found - when the requested service is either not active or could not be found in DoS.",
        },
    )
    def get(self, request, service__uid):
        logger.info("Request sent from host: %s", request.META["HTTP_HOST"])
        user = self.get_user_from_request(request)
        user_validation_error = self._validate_dos_user(user)
        if user_validation_error:
            return user_validation_error
        service_capacity = self._get_service_capcity(service__uid)
        service = self._get_service_or_none_from_capacity(service_capacity)
        service_validation_error = self._validate_service(service)
        if service_validation_error:
            return service_validation_error
        return self._serialized_get_capacity_response(service_capacity)

    @swagger_auto_schema(
        operation_description=description_post,
        manual_parameters=[service_uid_path_param],
        responses={
            200: CapacityStatusResponseSerializer,
            400: validation_error_response,
            401: authentication_error_response,
            403: "Forbidden - when a user does not have permissions to update capacity information for the requested service.",
            404: "Not Found - when the requested service to update is either not active, or could not be found in DoS.",
            500: "Internal Server Error - when an unexpected error is encountered whilst processing the request.",
        },
        request_body=CapacityStatusRequestPayloadSerializer,
    )
    def put(self, request, service__uid):
        logger.info("Request sent from host: %s", request.META["HTTP_HOST"])
        logger.info("Payload: %s", request.data)
        if self._can_edit_service(request, str(service__uid)):
            error_response = self._update_service_capacity(request, service__uid)
            if not error_response:
                return self._serialized_update_capacity_response(service__uid)
            return error_response
        return self._handle_cannot_edit_service_response(request, str(service__uid))

    @swagger_auto_schema(
        operation_description=description_post,
        manual_parameters=[service_uid_path_param],
        responses={
            200: CapacityStatusResponseSerializer,
            400: validation_error_response,
            401: authentication_error_response,
            403: "Forbidden - when a user does not have permissions to update capacity information for the requested service.",
            404: "Not Found - when the requested service to update is either not active, or could not be found in DoS.",
            500: "Internal Server Error - when an unexpected error is encountered whilst processing the request.",
        },
        request_body=CapacityStatusRequestPayloadSerializer,
    )
    def patch(self, request, service__uid, partial=True):
        logger.info("Request sent from host: %s", request.META["HTTP_HOST"])
        logger.info("Payload: %s", request.data)
        if self._can_edit_service(request, str(service__uid)):
            error_response = self._update_service_capacity(request, service__uid)
            if not error_response:
                return self._serialized_update_capacity_response(service__uid)
            return error_response
        return self._handle_cannot_edit_service_response(request, str(service__uid))

    def get_user_from_request(self, request):
        api_key = self.get_permissions()[0].get_key_model(request)
        return get_user_for_key(api_key)

    def _validate_dos_user(self, user):
        if user is None:
            msg = "Given Dos user does not exist"
            return Response(msg, status=status.HTTP_401_UNAUTHORIZED)
        if user.status != "ACTIVE":
            msg = "Given Dos user does not have an active status"
            return Response(msg, status=status.HTTP_401_UNAUTHORIZED)
        return None

    def _get_service_or_none_from_capacity(self, service_capacity):
        if service_capacity:
            return service_capacity.service
        return None

    def _validate_service(self, service):
        if service is None:
            msg = "Given service does not exist"
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        if service.statusid != 1:
            msg = "Given service does not have an active status"
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        return None

    def _get_service_capcity(self, service_uid):
        try:
            capacitiesManager = ServiceCapacities.objects.db_manager("dos")
            service_status = capacitiesManager.get(service__uid=service_uid)
            return service_status
        except ObjectDoesNotExist:
            return None

    def _serialized_get_capacity_response(self, service_capacity):
        logger.info("In status retrieval")
        model_data = CapacityStatusModelSerializer(service_capacity).data
        response = CapacityStatusResponseSerializer.convertModelToResponse(model_data)
        responseSerializer = CapacityStatusResponseSerializer(data=response)
        if responseSerializer.is_valid():
            return Response(responseSerializer.data)
        return Response(responseSerializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def _can_edit_service(self, request, service_uid):
        api_key = self.get_permissions()[0].get_key_model(request)
        return can_dos_user_api_key_edit_service(api_key, service_uid)

    def _update_service_capacity(self, request, service__uid):
        api_key = self.get_permissions()[0].get_key_model(request)
        context = {
            "apiUsername": api_key.dos_username,
            "apiUserId": api_key.dos_user_id,
        }
        payload_serializer = CapacityStatusRequestPayloadSerializer(data=request.data, context=context)
        if payload_serializer.is_valid():
            model_data = payload_serializer.convertToModel(data=request.data)
            model_serializer = CapacityStatusModelSerializer(data=model_data)
            if model_serializer.is_valid():

                self.partial_update(request, service__uid, partial=True)
                return None
            return Response(model_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response(payload_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def _serialized_update_capacity_response(self, service_uid):
        service_capacity = self._get_service_capcity(service_uid)
        return self._serialized_get_capacity_response(service_capacity)

    def _handle_cannot_edit_service_response(self, request, service_uid):
        user = self.get_user_from_request(request)
        user_validation_error = self._validate_dos_user(user)
        if user_validation_error:
            return user_validation_error
        service = get_dos_service_for_uid(service_uid, throwDoesNotExist=False)
        service_validation_error = self._validate_service(service)
        if service_validation_error:
            return service_validation_error
        msg = "Given DoS user does not have authority to edit the service"
        return Response(msg, status=status.HTTP_403_FORBIDDEN)
