import unittest

class TestGetView(unittest.TestCase):
    "Tests for the GET view"

    def test_default(self):
        self.assertEqual(1, 1, "Test message")
