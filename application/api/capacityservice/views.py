from .serializers.model_serializers import CapacityStatusModelSerializer
from .serializers.payload_serializer import CapacityStatusRequestPayloadSerializer
from .serializers.response_serializer import CapacityStatusResponseSerializer

from .models import ServiceCapacities

from django.http import HttpResponse
from rest_framework import status
from rest_framework.response import Response

from drf_yasg.utils import swagger_auto_schema

from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework_api_key.permissions import HasAPIKey

from .documentation import description_get, description_post, service_uid_path_param

import logging

logger = logging.getLogger(__name__)


class CapacityStatusView(RetrieveUpdateAPIView):
    permission_classes = [HasAPIKey]
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
        return self._process_service_status_retrieval(request, service__uid)

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
        return self._process_service_status_update(request, service__uid)

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
        self._process_service_status_update(request, service__uid)

    """
    Returns a JSON response containing service status details for the service specified via the
    service UID.
    """

    def _process_service_status_retrieval(self, request, service__uid):

        service_status = ServiceCapacities.objects.db_manager("dos").get(
            service__uid=service__uid
        )

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
        payloadSerializer = CapacityStatusRequestPayloadSerializer(data=request.data)
        if payloadSerializer.is_valid():
            modelData = payloadSerializer.convertToModel(data=request.data)
            modelSerializer = CapacityStatusModelSerializer(data=modelData)

            if modelSerializer.is_valid():
                self.partial_update(request, service__uid, partial=True)
                return self._process_service_status_retrieval(request, service__uid)

            return Response(modelSerializer.errors, status=status.HTTP_400_BAD_REQUEST)
        return Response(payloadSerializer.errors, status=status.HTTP_400_BAD_REQUEST)
