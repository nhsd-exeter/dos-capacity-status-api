import unittest
import json
from django.test import Client
from ..test_utils import TestUtils


class TestPutSuccess(unittest.TestCase):
    "Tests for the PUT view"
