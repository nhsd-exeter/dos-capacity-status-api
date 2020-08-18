from unittest import TestCase, mock
from datetime import datetime
from ..reporting import _get_request_execution_time, log_reporting_info, usage_reporting_logger
from ..reporting import api_logger, _retrieve_service_data
from time import gmtime as real_gmtime, strftime


class TestDosInterfaceReporting(TestCase):
    "Test for reporting to dos"

    reset_date_time_dummy = datetime.now()  # change to be 4 hours in the future
    modified_date_time_dummy = datetime.now()

    def _mock_service_info_return_value(self):
        service_info = {
            "name": "dummy-service",
            "typeid": 100,
            "modifiedby": "dummy-client",
            "color": "DUMMY-COLOR",
            "notes": "dummy notes about capacity status",
            "resetdatetime": self.reset_date_time_dummy,
            "modifieddate": self.modified_date_time_dummy,
        }
        parent_service_info = {"uid": "dummy-parent-uid"}
        dos_region_info = {"name": "dummy-dos-region-name"}

        return (service_info, parent_service_info, dos_region_info)

    @mock.patch("api.dos_interface.reporting.get_service_info")
    def test_retrieve_service_data(self, mock_get_service_info):
        mock_get_service_info.return_value = self._mock_service_info_return_value()
        service_uid = "149198"
        service_data = _retrieve_service_data(service_uid)
        expected_keys = [
            "CLIENT_NAME",
            "ORG_NAME",
            "ORG_TYPE",
            "PARENT_ORG",
            "DOS_REGION",
            "CAPACITY_STATUS",
            "NOTES",
            "RESET_DATE_TIME",
            "CHANGED_TIME",
        ]
        keys = list(service_data.keys())
        assert keys == expected_keys
        for key in keys:
            assert (type(service_data[key]) is str and service_data[key] != "") or type(service_data[key]) is None, (
                "key value not string or none key: " + str(key) + " value: " + str(service_data[key])
            )
            if key != "CLIENT_NAME" and key != "CAPACITY_STATUS":
                lower = key.lower()
                no_underscore = lower.replace("_", "")
                msg = "key " + key + " as lower with or without underscores is NOT present"
                assert lower in service_data[key] or no_underscore in service_data[key], msg

        assert service_data["CLIENT_NAME"] in ["dummy-client"]
        assert "capacity" in service_data["CAPACITY_STATUS"]

    def test_get_request_execution_time(self):
        class Request:
            META = {"HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat()}

        return_value = _get_request_execution_time(Request())
        msg = "The execution time (" + str(return_value) + ") is not within the expect values"
        assert return_value > 0 and return_value < 5, msg

    @mock.patch("api.dos_interface.reporting._retrieve_service_data")
    @mock.patch("api.dos_interface.reporting.gmtime")
    @mock.patch("api.dos_interface.reporting._get_request_execution_time")
    def test_log_reporting_info__success(
        self, mock_get_request_execution_time, mock_gmtime, mock_retrieve_service_data
    ):
        mock_get_request_execution_time.return_value = 2.5
        mock_gmtime.return_value = real_gmtime()
        service_uid = "0101010"
        mock_retrieve_service_data.return_value = {
            "CLIENT_NAME": "dummy_user",
            "ORG_ID": "org_id=" + service_uid,
            "ORG_NAME": "org_name=dummy_org_name",
            "DOS_REGION": "dosregion=dummy_dos_region",
            "PARENT_ORG": "parentorg=dummy_parent_org",
            "ORG_TYPE": "org_type=dummy_org_type",
            "CAPACITY_STATUS": "capacity=GREEN",
            "NOTES": "notes=dummy_notes",
            "RESET_DATE_TIME": "resetdatetime=01-01-1970 01:00",
            "CHANGED_TIME": "changedtime=01-01-1970 00:01",
        }
        usage_reporting_logger.info = mock.MagicMock()

        class Request:
            META = {
                "HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat(),
                "HTTP_X_REQUEST_ID": "dummy_id",
                "HTTP_X_CLIENT_IP": "0.0.0.1",
            }

        request = Request()
        return_value = log_reporting_info(service_uid, request)
        assert usage_reporting_logger.info.called
        mock_retrieve_service_data.assert_called_with(service_uid)
        expected_msg = strftime("%Y/%m/%d %H:%M:%S.000000%z", mock_gmtime.return_value)
        expected_msg += "|info|update|"
        expected_msg += request.META["HTTP_X_REQUEST_ID"] + "|"
        expected_msg += request.META["HTTP_X_CLIENT_IP"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["CLIENT_NAME"] + "|"
        expected_msg += "saveCapacityStatus|request|success|"
        expected_msg += mock_retrieve_service_data.return_value["ORG_ID"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["ORG_NAME"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["DOS_REGION"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["PARENT_ORG"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["ORG_TYPE"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["CAPACITY_STATUS"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["NOTES"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["RESET_DATE_TIME"] + "|"
        expected_msg += mock_retrieve_service_data.return_value["CHANGED_TIME"]
        expected_msg += "|execution_time=" + str(mock_get_request_execution_time.return_value)
        usage_reporting_logger.info.assert_called_with("%s", expected_msg)
        assert return_value is None

    def test_log_reporting_info__fail(self):
        api_logger.warning = mock.MagicMock()

        class Request:
            META = {
                "HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat(),
                "HTTP_X_REQUEST_ID": "dummy_id",
                "HTTP_X_CLIENT_IP": "0.0.0.1",
            }

        service_uid = "000000"
        return_value = log_reporting_info(service_uid, Request())
        api_logger.warning.assert_called_with(
            "No reporting service data was found for service: %s. The reporting log will not be produced.",
            str(service_uid),
        )
        assert return_value is None, "Expecting a none return for internal expection"
