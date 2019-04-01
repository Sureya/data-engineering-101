# in-built
import unittest
from datetime import  datetime
# 3rd party
from pyowm.exceptions import api_response_error

# custom
from version2 import fetch_weather_data


class TestWeatherApp(unittest.TestCase):
    def setUp(self):
        self.valid_api_key = "87d06047a03d842ac1e5ad1ea99a3355"
        self.invalid_api_key = "random string"
        self.null = None
        self.integer = 1
        self.valid_keys = ["extract_date", "sunset", "sunrise", "humidity", "max_temperature", "min_temperature",
                           "status"]

    def test_fetch_weather_data_with_valid_api_key(self):
        result = fetch_weather_data(self.valid_api_key)
        self.assertIsInstance(result, dict)
        self.assertEquals(set(self.valid_keys), set(result.keys()))

        # Data Quality checks
        self.assertIsInstance(datetime.strptime(result["extract_date"], '%Y-%m-%d'), datetime)
        self.assertIsInstance(datetime.strptime(result["sunset"], '%Y-%m-%d %H:%M:%S'), datetime)
        self.assertIsInstance(datetime.strptime(result["sunrise"], '%Y-%m-%d %H:%M:%S'), datetime)
        self.assertIsInstance(result["humidity"], int)
        self.assertIsInstance(result["max_temperature"], float)
        self.assertIsInstance(result["min_temperature"], float)
        self.assertIsInstance(result["status"], str)

    def test_fetch_weather_data_with_invalid_api_key(self):
        self.assertRaises(api_response_error.UnauthorizedError, fetch_weather_data, self.invalid_api_key)

    def test_fetch_weather_data_with_invalid_api_key_data_types(self):
        self.assertRaises(AssertionError, fetch_weather_data, self.integer)
        self.assertRaises(api_response_error.UnauthorizedError, fetch_weather_data, self.null)
