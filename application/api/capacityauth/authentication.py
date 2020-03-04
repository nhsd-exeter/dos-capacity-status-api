from abc import ABC, abstractclassmethod
from django.core.exceptions import ValidationError
from rest_framework.authentication import BaseAuthentication, exceptions
from rest_framework.authentication import get_authorization_header
from rest_framework_api_key.models import AbstractAPIKey, APIKey
from .models import DosUserAPIKey


class AbstractAPIKeyAuthentication(BaseAuthentication, ABC):
    """
    Simple Abstract API Key based authentication, that needs to be extended by
    a Authenticator class for the key class it's expect to handle e.g. APIKey.
    Clients should authenticate by passing the API key in the "Authorization"
    HTTP header, prepended with the string "Api-Key".  For example:
        Authorization: Api-Key Pa5YxY4M.SSEHlZALYfBiPPVd6d6lGOIavS9kuybr

    """

    keyword = "Api-Key"
    model_class = DosUserAPIKey
    model = None

    @abstractclassmethod
    def get_model_class(self):
        """Abstract get_model_class needs to return a class that extends the AbstractAPIKey class"""
        return AbstractAPIKey

    def get_model(self):
        if self.model is not None:
            return self.model

        return self.model_class

    def authenticate(self, request):
        auth = get_authorization_header(request).split()

        if not auth or auth[0].lower() != self.keyword.lower().encode():
            return None

        if len(auth) == 1:
            msg = "Invalid Api-Key header. No credentials provided."
            raise exceptions.AuthenticationFailed(msg)
        elif len(auth) > 2:
            msg = "Invalid Api-Key header. Key string should not contain spaces."
            raise exceptions.AuthenticationFailed(msg)

        try:
            api_key = auth[1].decode()
        except UnicodeError:
            msg = "Invalid Api-Key header. key string should not contain invalid characters."

            raise exceptions.AuthenticationFailed(msg)

        return self.authenticate_credentials(api_key)

    def authenticate_credentials(self, key):
        model = self.get_model()
        if not model.objects.is_valid(key):
            raise exceptions.AuthenticationFailed("Invalid API key.")

        return (None, key)

    def authenticate_header(self, request):
        return self.keyword


class APIKeyAuthentication(AbstractAPIKeyAuthentication):
    """
    Simple API Key based authentication for handling APIKey instances.
    Clients should authenticate by passing the API key in the "Authorization"
    HTTP header, prepended with the string "Api-Key".  For example:
        Authorization: Api-Key Pa5YxY4M.SSEHlZALYfBiPPVd6d6lGOIavS9kuybr

    """

    def get_model_class(self):
        return APIKey


class DosUserAPIKeyAuthentication(AbstractAPIKeyAuthentication):
    """
    Simple API Key based authentication for handling DosUserAPIKey instances.
    Clients should authenticate by passing the API key in the "Authorization"
    HTTP header, prepended with the string "Api-Key".  For example:
        Authorization: Api-Key Pa5YxY4M.SSEHlZALYfBiPPVd6d6lGOIavS9kuybr

    """

    def get_model_class(self):
        return DosUserAPIKey
