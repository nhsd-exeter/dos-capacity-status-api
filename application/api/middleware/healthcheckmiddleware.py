from django.http import HttpResponse
from rest_framework import status


class HealthCheckMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == '/api/health':
            return HttpResponse(status=status.HTTP_200_OK, content='Health Okay from CS API')
        return self.get_response(request)
