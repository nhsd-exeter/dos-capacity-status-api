import unittest

from ....serializers.response_serializer import CapacityStatusResponseSerializer


class TestCapacityStatusResponseSerializer(unittest.TestCase):
    "Tests for the CapacityStatusResponseSerializer class"

    def test_default(self):
        self.assertEqual(1, 1, "Test message")
