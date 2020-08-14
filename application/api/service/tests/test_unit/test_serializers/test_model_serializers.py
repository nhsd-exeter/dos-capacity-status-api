import unittest
from unittest.mock import patch, MagicMock


from ....serializers.model_serializers import (
    CapacitystatusesSerializer,
    CapacityStatusModelSerializer,
    ServicesSerializer,
)


class TestModelSerializers(unittest.TestCase):
    "Tests for the ModelSerializer class"

    def test_ServicesSerializer(self):
        service = ServicesSerializer(read_only=True)
        assert service.Meta.fields == ("id", "uid", "name", "publicname")

    def test_CapacitystatusesSerializer(self):
        status = CapacitystatusesSerializer(required=True)
        assert status.Meta.fields == ("color",)

    def test_CapacityStatusModelSerializer(self):
        service_details = CapacityStatusModelSerializer()
        assert service_details.Meta.fields == (
            "id",
            "notes",
            "modifiedbyid",
            "modifiedby",
            "modifieddate",
            "service",
            "resetdatetime",
            "status",
        )

    @patch("api.dos_interface.models.Capacitystatuses.objects.db_manager")
    def test_CapacityStatusModelSerializer_update(self, mock_model):
        service_details = CapacityStatusModelSerializer()
        mock_instance = MagicMock()
        validated_data = {"status": {"color": "RED"}, "test": "tests"}
        service_details.update(instance=mock_instance, validated_data=validated_data)
        mock_model.assert_called()
