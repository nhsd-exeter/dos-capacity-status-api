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

from .documentation import description_get, description_post, service_uid_path_param
from api.capacityauth.authorise import (
    can_dos_user_api_key_edit_service,
    get_user_for_key,
)
from api.dos.queries import get_dos_service_for_uid

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
            404: "The capacity status for the requested service was not found.",
            400: "Bad Request - upon receiving a corrupt request or a request which fails API validation rules.",
            401: "Unauthorized - when a user is unauthorized to use this API.",
        },
    )
    def get(self, request, service__uid):
        logger.info("Request sent from host: %s", request.META["HTTP_HOST"])
        is_user_valid, msg, sc = self._handle_check_dos_user(request)
        if is_user_valid:
            service_capacity = self._get_service_capcitystatus(service__uid)
            service = self._get_service_or_none_from_capacity(service_capacity)
            is_valid_service, msg, sc = self._handle_check_service(service)
            if is_valid_service:
                return self._serialized_get_capacity_response(service_capacity)
        return Response(msg, status=sc)

    @swagger_auto_schema(
        operation_description=description_post,
        manual_parameters=[service_uid_path_param],
        responses={
            200: CapacityStatusResponseSerializer,
            400: "Bad Request - upon receiving a corrupt request or a request which fails API validation rules.",
            401: "Unauthorized - when a user is unauthorized to use this API.",
            403: "Forbidden - when a user is not authorized to update the status of the requested service.",
            404: "Not Found - when the requested service to update could not be found in DoS.",
            408: "Request Timeout - when the server times out waiting for a request to be processed.",
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
            400: "Bad Request - upon receiving a corrupt request or a request which fails API validation rules.",
            401: "Unauthorized - when a user is unauthorized to use this API.",
            403: "Forbidden - when a user is not authorized to update the status of the requested service.",
            404: "Not Found - when the requested service to update could not be found in DoS.",
            408: "Request Timeout - when the server times out waiting for a request to be processed.",
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

    def _handle_check_dos_user(self, request):
        api_key = self.get_permissions()[0].get_key_model(request)
        user = get_user_for_key(api_key)
        if user is None:
            is_valid_user = False
            status_msg = "Given DoS user does not exist"
            status_code = status.HTTP_401_UNAUTHORIZED
        elif user.status != "ACTIVE":
            is_valid_user = False
            status_msg = "Given DoS user is inactive"
            status_code = status.HTTP_401_UNAUTHORIZED
        else:
            is_valid_user = True
            status_msg = None
            status_code = None
        return is_valid_user, status_msg, status_code

    def _get_service_or_none_from_capacity(self, service_capacity):
        if service_capacity:
            return service_capacity.service
        return None

    def _handle_check_service(self, service):
        if service is None:
            is_valid_service = False
            status_msg = "Given service does not exist"
            status_code = status.HTTP_404_NOT_FOUND
        elif service.statusid != 1:
            is_valid_service = False
            status_msg = "Given service is not active service"
            status_code = status.HTTP_404_NOT_FOUND
        else:
            is_valid_service = True
            status_msg = None
            status_code = None
        return is_valid_service, status_msg, status_code

    def _get_service_capcitystatus(self, service_uid):
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
        request.data["apiUsername"] = api_key.dos_username
        payload_serializer = CapacityStatusRequestPayloadSerializer(data=request.data)
        if payload_serializer.is_valid():
            model_data = payload_serializer.convertToModel(data=request.data)
            model_serializer = CapacityStatusModelSerializer(data=model_data)
            if model_serializer.is_valid():
                self.partial_update(request, service__uid, partial=True)
                return None
            return Response(model_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response(payload_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def _serialized_update_capacity_response(self, service_uid):
        service_capacity = self._get_service_capcitystatus(service_uid)
        return self._serialized_get_capacity_response(service_capacity)

    def _handle_cannot_edit_service_response(self, request, service_uid):
        is_valid_user, msg, sc = self._handle_check_dos_user(request)
        if is_valid_user:
            service = get_dos_service_for_uid(service_uid, throwDoesNotExist=False)
            is_valid_service, msg, sc = self._handle_check_service(service)
            if is_valid_service:
                msg = "Given DoS user does not have authority to edit the service"
                sc = status.HTTP_403_FORBIDDEN
        return Response(msg, status=sc)

    """
    Returns a JSON response containing service status details for the service specified via the
    service UID.
    """

    def _process_service_status_retrieval(self, request, service__uid):
        api_key = self.get_permissions()[0].get_key_model(request)
        is_valid_user, msg, sc = self._handle_check_dos_user(api_key)
        if not is_valid_user:
            return Response(msg, status=sc)

        try:
            capacitiesManager = ServiceCapacities.objects.db_manager("dos")
            service_status = capacitiesManager.get(service__uid=service__uid)
            service = service_status.service
        except ObjectDoesNotExist:
            service = None

        is_valid_service, msg, sc = self._handle_check_dos_service(service)
        if not is_valid_service:
            return Response(msg, status=sc)

        logger.info("In status retrieval")
        modelSerializer = CapacityStatusModelSerializer(service_status)

        responseData = CapacityStatusResponseSerializer.convertModelToResponse(
            modelSerializer.data
        )

        responseSerializer = CapacityStatusResponseSerializer(data=responseData)

        if responseSerializer.is_valid():
            return Response(responseSerializer.data)

        return Response(responseSerializer.errors, status=status.HTTP_400_BAD_REQUEST)

    """
    Updates capacity status details for a service specified by the service UID and returns
    a JSON response containing the newly updated capacity status details for the service.
    """

    def _process_service_status_update(self, request, service__uid):
        api_key = self.get_permissions()[0].get_key_model(request)
        if not can_dos_user_api_key_edit_service(api_key, str(service__uid)):
            return self._handle_cannot_edit_service_response(api_key, str(service__uid))

        request.data["apiUsername"] = api_key.dos_username
        payloadSerializer = CapacityStatusRequestPayloadSerializer(data=request.data)
        if payloadSerializer.is_valid():
            modelData = payloadSerializer.convertToModel(data=request.data)
            modelSerializer = CapacityStatusModelSerializer(data=modelData)

            if modelSerializer.is_valid():
                self.partial_update(request, service__uid, partial=True)
                return self._process_service_status_retrieval(request, service__uid)

            return Response(modelSerializer.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response(payloadSerializer.errors, status=status.HTTP_400_BAD_REQUEST)
