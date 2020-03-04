from django.test.runner import DiscoverRunner
from .test_regression.test_utils import TestUtils


class TestRunner(DiscoverRunner):
    def run_tests(self, test_labels, extra_tests=None, **kwargs):

        # Set up API Key for Test User
        # utils = TestUtils()

        super().run_tests(test_labels, extra_tests=None, **kwargs)

