from unittest import TestCase, mock
from datetime import datetime
from ..reporting import _get_request_execution_time, log_reporting_info, usage_reporting_logger
from ..reporting import _retrieve_service_data, api_logger
from time import gmtime as real_gmtime, strftime


class TestDosInterfaceReporting(TestCase):
    "Test for reporting to dos"

    def test_retrieve_service_data(self):
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
            assert type(service_data[key]) is str and service_data[key] != ""
            if key != "CLIENT_NAME" and key != "CAPACITY_STATUS":
                lower = key.lower()
                no_underscore = lower.replace("_", "")
                msg = "key " + key + " as lower with or without underscores is NOT present"
                assert lower in service_data[key] or no_underscore in service_data[key], msg

        assert service_data["CLIENT_NAME"] == "EditUser"
        assert "capacity" in service_data["CAPACITY_STATUS"]

    def test_get_request_execution_time(self):
        class Request:
            META = {"HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat()}

        return_value = _get_request_execution_time(Request())
        msg = "The execution time (" + str(return_value) + ") is not within the expect values"
        assert return_value > 0 and return_value < 5, msg

    @mock.patch("api.dos_interface.reporting.gmtime")
    @mock.patch("api.dos_interface.reporting._get_request_execution_time")
    def test_log_reporting_info__sucess(self, mock_get_request_execution_time, mock_gmtime):
        mock_get_request_execution_time.return_value = 2.5
        mock_gmtime.return_value = real_gmtime()
        usage_reporting_logger.info = mock.MagicMock()

        class Request:
            META = {
                "HTTP_X_REQUEST_RECEIVED": datetime.now().isoformat(),
                "HTTP_X_REQUEST_ID": "dummy_id",
                "HTTP_X_CLIENT_IP": "0.0.0.1",
            }

        service_uid = "149198"
        return_value = log_reporting_info(service_uid, Request())
        assert usage_reporting_logger.info.called
        expected_msg = strftime("%Y/%m/%d %H:%M:%S.000000%z", mock_gmtime.return_value)
        expected_msg += "|info|update|dummy_id|0.0.0.1|EditUser|saveCapacityStatus|request|success"
        expected_msg += "|org_id=" + service_uid + "|org_name=Dentist - Castle View Dental Practice, Dudley"
        expected_msg += "|dosregion=Pharmacist - Rigby & Higgson Pharmacy - Church Street - Westhoughton"
        expected_msg += "|parentorg=153455|org_type=12|capacity=RED|notes=Capacity status set by Capacity Status API"
        expected_msg += "|resetdatetime=07-08-2020 13:48|changedtime=07-08-2020 09:48"
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
