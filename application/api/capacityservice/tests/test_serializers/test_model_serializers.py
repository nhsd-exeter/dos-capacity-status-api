import unittest

from ...serializers.model_serializers import CapacityStatusModelSerializer


class TestModelSerializers(unittest.TestCase):
    "Tests for the ModelSerializer class"

    def test_default(self):
        self.assertEqual(1, 1, "Test message")
